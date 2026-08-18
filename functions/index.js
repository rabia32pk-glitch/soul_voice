const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const cors = require("cors")({ origin: true });

admin.initializeApp();

// IMPORTANT: Yahan apni Gmail aur App Password likhein
const gmailEmail = "rabia32pk@gmail.com";
const gmailPassword = "szdh nfpt gqmq wrhv";

const mailTransport = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: gmailEmail,
        pass: gmailPassword,
    },
});

exports.sendVerificationCode = functions.https.onCall(async (data, context) => {
    const email = data.email;

    if (!email) {
        throw new functions.https.HttpsError("invalid-argument", "Email is required.");
    }

    // 6 digit ka random code
    const code = Math.floor(100000 + Math.random() * 900000).toString();

    try {
        // Firestore mein temporary save
        await admin.firestore().collection("verificationCodes").doc(email).set({
            code: code,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            verified: false,
        });

        // Email format
        const mailOptions = {
            from: `"Soul Voice" <${gmailEmail}>`,
            to: email,
            subject: "Soul Voice Account Verification Code",
            html: `
        <h3>Welcome!</h3>
        <p>Your verification code is:</p>
        <h1 style="color: #4CAF50; font-size: 32px;">${code}</h1>
        <p>This code will expire in 15 minutes.</p>
      `,
        };

        await mailTransport.sendMail(mailOptions);
        return { success: true, message: "Code sent successfully" };

    } catch (error) {
        console.error("Error sending email:", error);
        throw new functions.https.HttpsError("internal", "Error sending email.");
    }
});
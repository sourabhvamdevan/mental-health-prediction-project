const User = require("../models/user-models");
const bcrypt = require("bcrypt");

const signup = async (req, res) => {
    try {
        const { userName, email, password, phone } = req.body;
        const userExist = await User.findOne({ email });
        if(userExist) {
            return res.status(400).json({ success: false, message: "email already exist" });
        }
        const userCreated = await User.create({ userName, email, phone, password });
        res.status(201).json({ success: true, message: "User registered successfully" })
    } catch (error) {
        console.log(error);
    }
}

const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const userExist = await User.findOne({ email });
        if(!userExist) {
            return res.status(400).json({ message: "Invalid Credentials" });
        }
        const user = await bcrypt.compare(password, userExist.password);
        if(user) {
            res.status(200).json({
                success: true,
                message: "Login Successful",
                userId: userExist._id.toString()
            })
        } else {
            res.status(401).json({ message: "Invalid email or password "});
        }
    } catch (error) {
        console.log(error);
    }
}

// const login = async (req, res) => {
//     try {
//         const { email, password } = req.body;

//         const userExist = await User.findOne({ email });

//         if (!userExist) {
//             return res.status(400).json({ message: "Invalid Credentials" });
//         }

//         console.log("User Exists:", userExist);
//         console.log("Entered Password:", password);
//         console.log("Stored Hashed Password:", userExist.password);

//         const isMatch = await bcrypt.compare(password, userExist.password);

//         console.log("Password Match:", isMatch);

//         if (isMatch) {
//             return res.status(200).json({
//                 message: "Login Successful",
//                 userId: userExist._id.toString()
//             });
//         } else {
//             return res.status(401).json({ message: "Invalid email or password" });
//         }
//     } catch (error) {
//         console.log(error);
//         res.status(500).json({ message: "Internal Server Error" });
//     }
// };

module.exports = { signup, login }
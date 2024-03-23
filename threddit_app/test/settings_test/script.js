const express = require('express');
const fs = require('fs');
const bodyParser = require('body-parser');
const app = express();
const PORT = 3001;

app.use(bodyParser.json());

const dbFile = 'test.json';
app.post('/api/change-password', (req, res) => {
    const { user_id, current_password, new_password, confirmed_password } = req.body;

    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.user_id === user_id);
        if (confirmed_password !== new_password) {
            return res.status(402).json({ error: "The passwords you enter don't match" });
        }
        if (!userToUpdate) {
            console.log("User not found");
            return res.status(404).json({ error: 'User not found' });

        }
        if (userToUpdate.password !== current_password) {

            return res.status(401).json({ error: 'Current password is incorrect' });
        } else {

            userToUpdate.password = new_password;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'Password changed successfully' });
            });
        }


    });
});
app.post('/api/change-email', (req, res) => {
    const { user_id, current_password, new_email } = req.body;

    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.user_id === user_id);
        if (!userToUpdate) {
            return res.status(404).json({ error: 'User not found' });
        }
        if (userToUpdate.password !== current_password) {
            return res.status(401).json({ error: 'Reddit password is incorrect' });
        } else {

            userToUpdate.email = new_email;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'Email changed successfully' });
            });
        }


    });
});
app.post('/api/change-gender', (req, res) => {
    const { user_id, gender, } = req.body;

    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.user_id === user_id);
        if (!userToUpdate) {
            return res.status(404).json({ error: 'User not found' });
        }
        else {

            userToUpdate.gender = gender;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'Email changed successfully' });
            });
        }


    });
});
app.get('/api/user-info', (req, res) => {
    const { user_id } = req.query;
    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToGet = users.find(user => user.user_id == user_id);
        if (!userToGet) {
            return res.status(404).json({ error: 'User not found' });
        }
        const username = userToGet.username;
        const email = userToGet.email;

        res.json({ username, email, user_id });
    });
});
app.listen(PORT, () => {
    console.log("Server is running on port ${PORT}");
});
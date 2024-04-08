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
app.post('/api/confirm-password', (req, res) => {
    const { user_id, confirmed_password } = req.body;

    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.user_id === user_id);
        if (userToUpdate.password == confirmed_password) {
            return res.status(200).json({ message: 'Correct password' });

        } else {
            return res.status(400).json({ error: 'Inncorect Password' });
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
                res.json({ message: 'Gender changed successfully' });
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
        const gender = userToGet.gender;
        const blocked = userToGet.blocked;
        const notification = userToGet.notifications;
        const isFollowable = userToGet.isFollowable;
        res.json({ username, email, user_id, gender, blocked, notification, isFollowable});
    });
});
app.listen(PORT, () => {
    console.log("Server is running on port ${PORT}");
});


app.post('/api/notification', (req, res) => {
    const { user_id } = req.query;
    const { isOn } = req.body;
    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.user_id == user_id);
        if (!userToUpdate) {
            return res.status(404).json({ error: 'User not found' });
        }
        else {

            userToUpdate.notifications = isOn;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'Notification successfully changed' });
            });
        }
    });
});
app.post('/api/followable', (req, res) => {
    const { user_id } = req.query;
    const { isOn } = req.body;
    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.user_id == user_id);
        if (!userToUpdate) {
            return res.status(404).json({ error: 'User not found' });
        }
        else {

            userToUpdate.isFollowable = isOn;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'Followable successfully changed' });
            });
        }
    });
});

app.get('/api/search-user', (req, res) => {
    const { query } = req.query;

    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }

        const dataObject = JSON.parse(data);
        const users = dataObject.users;
        const matchedUsers = users.filter(user => user.username.toLowerCase().startsWith(query.toLowerCase()));
        res.json(matchedUsers);
    });
});

app.post('/api/block-user', (req, res) => {
    const { blockUsername } = req.body;
    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.username == blockUsername);
        if (!userToUpdate) {
            return res.status(404).json({ error: 'User not found' });
        }
        else {

            userToUpdate.blocked = true;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'User blocked successfully' });
            });
        }
    });

});
app.post('/api/unblock-user', (req, res) => {
    const { blockUsername } = req.body;

    fs.readFile(dbFile, 'utf-8', (err, data) => {
        if (err) {
            console.error('Error reading file:', err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        const dataObject = JSON.parse(data);
        const users = dataObject.users
        const userToUpdate = users.find(user => user.username == blockUsername);
        if (!userToUpdate) {
            return res.status(404).json({ error: 'User not found' });
        }
        else {

            userToUpdate.blocked = false;
            fs.writeFile(dbFile, JSON.stringify(dataObject, null, 2), err => {
                if (err) {
                    console.error('Error writing file:', err);
                    return res.status(500).json({ error: 'Internal Server Error' });
                }
                res.json({ message: 'User unblocked successfully' });
            });
        }
    });

});
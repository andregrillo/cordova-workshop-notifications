var exec = require('cordova/exec');

exports.sendNotification = function (message, title, seconds, success, error) {
    exec(success, error, 'MyNotifications', 'sendNotification', [message, title, seconds]);
};

exports.requestPermission = function (success, error) {
    exec(success, error, 'MyNotifications', 'requestPermission');
};
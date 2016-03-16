var Promise = require('bluebird');
module.exports = function (req, res, next) {
	var userId = req.param('userId');
	var loginToken = req.param('loginToken');
	return User.findOne({
		id: userId,
		loginToken: loginToken
	}).then(function(matchedUser) {
		if (!matchedUser) {
			return res.send(400, '请先登录');
		}
		return Promise.resolve(next());
	}).catch(function(err) {
		return res.send(400, err);
	});
};
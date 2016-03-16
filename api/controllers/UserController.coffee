###
UserController

@description :: Server-side logic for managing users
@help        :: See http://links.sailsjs.org/docs/controllers
###
Promise = require 'bluebird'
module.exports =
    submitLogin: (req, res) ->
        username = req.param 'username'
        password = req.param 'password'
        comparePassword = Promise.promisify require('bcrypt').compare
        userId = null
        User.findOne username: username
        .then (foundUserWithUsername) ->
            return Promise.reject '用户没找到' if not foundUserWithUsername
            userId = foundUserWithUsername.id
            comparePassword password, foundUserWithUsername.password
        .then (match) ->
            return Promise.reject '密码不正确' if not match
            loginToken = Toolbox.generateLoginToken()
            User.update id: userId, {loginToken: loginToken}
        .then (updatedUsers) ->
            return Promise.reject '服务器错误' if not updatedUsers
            req.session.userId = updatedUsers[0].id
            res.json updatedUsers[0]
        .catch (err) -> res.send 400, err

    submitRegister: (req, res) ->
        username = req.param 'username'
        password = req.param 'password'
        email = req.param 'email'
        bcrypt = Promise.promisifyAll require 'bcrypt'
        validator = require 'validator'
        return res.send(400, '请输入用户名') if not username
        return res.send(400, '请输入密码') if not password
        return res.send(400, '请输入邮箱') if not email
        return res.send(400, '请输入有效的邮箱') if not validator.isEmail email
        return res.send(400, '密码长度必须为6-20位') if password.length < 6 or password.length > 20
        loginToken = Toolbox.generateLoginToken()
        User.findOne username: username
        .then (foundUserWithUsername) ->
            return Promise.reject '用户名已存在' if foundUserWithUsername
            User.findOne email: email
        .then (foundUserWithEmail) ->
            return Promise.reject '邮箱已存在' if foundUserWithEmail
            bcrypt.genSaltAsync 10
        .then (salt) -> bcrypt.hashAsync password, salt
        .then (hash) ->
            User.create
                username: username
                password: hash
                email: email
                loginToken: loginToken
        .then (createdUser) ->
            req.session.userId = createdUser.id
            res.json createdUser
        .catch (err) -> res.send 400, err


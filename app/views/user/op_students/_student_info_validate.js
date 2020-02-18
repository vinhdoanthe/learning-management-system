$("#student_info_form").validate({
    //error place
    errorPlacement: function (error, element) {
        error.insertAfter(element);
    },
    rules: {

        // username is required with max of 20 and min of 6
        "user[username]": {
            required: true,
            maxlength: 20,
            minlength: 6,
            validate_username: 500
        },
        // // email is required with format
        // "user[email]": {
        //     required: true,
        //     email: true
        // },
        // // password is required
        // "user[password]": {
        //     required: true
        // },
        // // password_confirmation is required and is the same with password
        // "user[password_confirmation]": {
        //     required: true,
        //     equalTo: "#user_password"
        // },
        // // introduction is optional with maxlenght 500
        // "user[password_confirmation]": {
        //     maxlength: 500
        // }
    },
    // error messages
    messages: {
        username: {
            required: "Username is required.",
            maxlength: "Username must be less than 20",
            minlength: "Username must be more than 6"
        },
        // mail:{
        //     required: "Email is required",
        //     email: "Please enter a valid email address"
        // },
        // password: {
        //     required: "Password is required"
        // },
        // password_confirmation: {
        //     required: "Password confirmation is required",
        //     equalTo: "Password and password confirmation must be same"
        // }
    }
});

$.validator.addMethod("valid_username", function (value, element) {
    return this.required(element) || isValidUsername(value);
}, "Username chỉ gồm số và chữ không dấu, không bao gồm khoảng trắng");

function isValidUsername(str) {
    let regexUsername = "^[a-zA-Z0-9]*$";
    return  str.match(regexUsername);
}
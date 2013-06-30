(function(name, definition) {
    var theModule = definition(),
        // this is considered "safe":
        hasDefine = typeof define === 'function' && define.amd,
        // hasDefine = typeof define === 'function',
        hasExports = typeof module !== 'undefined' && module.exports;

    if (hasDefine) { // AMD Module
        define(theModule);
    } else if (hasExports) { // Node.js Module
        module.exports = theModule;
    } else { // Assign to common namespaces or simply the global object (window)
        (this.jQuery || this.ender || this.$ || this)[name] = theModule;
    }
})('iitPasswordReset', function() {

    var controller = this;
    var settings = {
        ControlPath: '',
        UnknownException: '',
        PasswordsNotMatch: '',
        PasswordLength: 7,
        UserId: -1,
        PasswordTooShort: ''
    };

    controller.ShowMessage = function(level, msg) {
        $("#passwordReset .dnnFormMessage").remove();
        var className;
        switch (level) {
        case "success":
            className = "dnnFormSuccess";
            break;
        case "warning":
            className = "dnnFormWarning";
            break;
        case "info":
            className = "dnnFormInfo";
            break;
        case "error":
            className = "dnnFormValidationSummary";
            break;
        default:
            className = "dnnFormSuccess";
            break;
        }
        $("<div />").addClass("dnnFormMessage").addClass(className).text(msg).prependTo($("#passwordReset"));
    };

    return {
        Init: function(config) {
            settings = $.extend({}, settings, config);
        },
        ResetPassword: function() {
            $.iitPasswordReset.ToggleLoader();

            if ($.iitPasswordReset.ValidatePasswords()) {
                var currentPassword = jQuery("input[id$='txtCurrentPassword']").size() > 0 ? encodeURIComponent(jQuery("input[id$='txtCurrentPassword']").val()) : "";
                $.ajax({
                    url: settings.ControlPath + "PasswordReset.ashx",
                    data: "method=resetPassword&UserId=" + settings.UserId + "&currentPassword=" + currentPassword + "&newPassword=" + encodeURIComponent(jQuery("input[id$='txtNewPassword']").val()) + "&confirmPassword=" + encodeURIComponent(jQuery("input[id$='txtConfirmPassword']").val()),
                    type: "POST",
                    cache: false,
                    dataType: "json",
                    success: function(data, status) {
                        $.iitPasswordReset.ToggleLoader();
                        $.iitPasswordReset.ClearPasswords();
                        if (data != null) {
                            if (data.isBad) {
                                controller.ShowMessage("error", data.msg);
                            } else {
                                controller.ShowMessage("success", data.msg);
                            }

                        } else {
                            controller.ShowMessage("error", settings.UnknownException);
                        }


                    },
                    error: function(msg) {
                        $.iitPasswordReset.ToggleLoader();
                        controller.ShowMessage("error", settings.UnknownException);
                        $.iitPasswordReset.ClearPasswords();
                    }
                });
            }
        },
        ToggleLoader: function() {
            if (jQuery("#btnResetPassword").attr("disabled") != "disabled") {
                jQuery("#resetPassword_ajaxLoader").show();
                jQuery("#btnResetPassword").attr("disabled", "disabled");
            } else {
                jQuery("#resetPassword_ajaxLoader").hide();
                jQuery("#btnResetPassword").removeAttr("disabled");

            }

        },
        ClearPasswords: function() {
            jQuery("input[id$='txtCurrentPassword']").val("");
            jQuery("input[id$='txtNewPassword']").val("");
            jQuery("input[id$='txtConfirmPassword']").val("");
        },
        ValidatePasswords: function() {
            if (jQuery("input[id$='txtNewPassword']").val().length >= settings.PasswordLength) {


                if (jQuery("input[id$='txtNewPassword']").val() != jQuery("input[id$='txtConfirmPassword']").val() || jQuery("input[id$='txtNewPassword']").val() == "") {
                    controller.ShowMessage("warning", settings.PasswordsNotMatch);
                    $.iitPasswordReset.ToggleLoader();
                    $.iitPasswordReset.ClearPasswords();
                    return false;

                } else {
                    return true;
                }
            } else {
                controller.ShowMessage("warning", settings.PasswordTooShort.replace("{0}",settings.PasswordLength));
                $.iitPasswordReset.ToggleLoader();
                $.iitPasswordReset.ClearPasswords();
                return false;
            }
        }
    };
});


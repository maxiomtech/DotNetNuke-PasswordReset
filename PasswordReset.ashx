<%@ WebHandler Language="C#" Debug="true" Class="InspectorIT.PasswordReset.PasswordReset" %>
// ***********************************************************************
// Author           : Jonathan Sheely
// Created          : 06-29-2013
//
// Last Modified By : Jonathan Sheely
// Last Modified On : 06-30-2013
// ***********************************************************************
// <copyright file="PasswordReset.ascx.cs" company="InspectorIT">
//     Copyright (c) InspectorIT. All rights reserved.
// </copyright>
// <summary></summary>
// ***********************************************************************
using System;
using System.Web;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Entities.Users;
using DotNetNuke.Security.Membership;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Services.Localization;

namespace InspectorIT.PasswordReset
{

    public class PasswordReset : IHttpHandler
    {

        private bool _isAdministrator = false;

        public void ProcessRequest(HttpContext context)
        {

            context.Response.ContentType = "application/json";
            context.Response.ExpiresAbsolute = DateTime.Now;
            context.Response.Expires = -1;
            context.Response.CacheControl = "no-cache";
            context.Response.AddHeader("Pragma", "no-cache");
            context.Response.AddHeader("Pragma", "no-store");
            context.Response.AddHeader("cache-control", "no-cache");
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetNoServerCaching();

            var Request = context.Request;
            var Response = context.Response;
            string method = "";
            string username = "";
            UserInfo authuser;
            UserInfo updateUser;
            try
            {
                var portalSettings = PortalController.GetCurrentPortalSettings();
                username = HttpContext.Current.User.Identity.Name;

                if (username != "")
                {
                    if (Request.HttpMethod == "POST")
                    {
                        authuser = UserController.GetUserByName(portalSettings.PortalId, username);
                        if (authuser.IsInRole("Administrators") || authuser.IsSuperUser)
                        {
                            _isAdministrator = true;
                        }

                        if (_isAdministrator || authuser.UserID == Convert.ToInt32(Request.Form["UserId"]))
                        {
                            updateUser = UserController.GetUserById(portalSettings.PortalId,
                                                                    Convert.ToInt32(Request.Form["UserId"]));
                            method = Request.Form["method"];
                            switch (method)
                            {
                                case "resetPassword":
                                    Response.Write(AttemptPasswordReset(updateUser, Request.Form["currentPassword"],
                                                                        Request.Form["newPassword"],
                                                                        Request.Form["confirmPassword"]));
                                    break;
                            }
                        }
                        else
                        {
                            Response.Write(
                                JsonExtensionsWeb.ToJson(new PasswordResponse()
                                    {
                                        isBad = true,
                                        msg = Localization.GetString("txtMessage.PasswordPermission",
                                                                     "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                                    }));
                        }

                    }
                }
                else
                {
                    Response.Write(
                        JsonExtensionsWeb.ToJson(new PasswordResponse()
                            {
                                isBad = true,
                                msg = Localization.GetString("txtMessage.NotLoggedIn",
                                                             "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                            }));
                }


            }
            catch (Exception)
            {

                throw;
            }

        }

        private string AttemptPasswordReset(UserInfo user, string currentPassword, string newPassword,
                                            string confirmPassword)
        {
            if (user != null)
            {
                if (!MembershipProviderConfig.RequiresQuestionAndAnswer)
                {
                    if (_isAdministrator | UserController.GetPassword(ref user, "") == currentPassword)
                    {
                        if (newPassword.Length >= MembershipProviderConfig.MinPasswordLength)
                        {
                            if (newPassword != "" & newPassword == confirmPassword)
                            {
                                try
                                {
                                    UserController.ChangePassword(user, currentPassword, newPassword);
                                    return
                                        JsonExtensionsWeb.ToJson(new PasswordResponse()
                                            {
                                                isBad = false,
                                                msg =
                                                    Localization.GetString("txtMessage.PasswordUpdated",
                                                                           "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                                            });
                                }
                                catch (Exception ex)
                                {
                                    Exceptions.LogException(ex);
                                    return UnknownError();
                                }
                            }
                            else
                            {
                                return
                                    JsonExtensionsWeb.ToJson(new PasswordResponse()
                                        {
                                            isBad = true,
                                            msg =
                                                Localization.GetString("txtMessage.PasswordsNotMatch",
                                                                       "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                                        });
                            }
                        }
                        else
                        {
                            return JsonExtensionsWeb.ToJson(new PasswordResponse()
                                {
                                    isBad = true,
                                    msg = string.Format(
                                        Localization.GetString("txtMessage.PasswordTooShort",
                                                               "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset"),
                                        MembershipProviderConfig.MinPasswordLength)
                                });
                        }
                    }
                    else
                    {
                        return
                            JsonExtensionsWeb.ToJson(new PasswordResponse()
                                {
                                    isBad = true,
                                    msg =
                                        Localization.GetString("txtMessage.CurrentPasswordIncorrect",
                                                               "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                                });
                    }
                }
                else
                {
                    return
                        JsonExtensionsWeb.ToJson(new PasswordResponse()
                            {
                                isBad = true,
                                msg = "Password Question & Answer is enabled and not yet implemented in this module."
                            });
                }
            }
            else
            {
                return
                    JsonExtensionsWeb.ToJson(new PasswordResponse()
                        {
                            isBad = true,
                            msg =
                                Localization.GetString("txtMessage.NotLoggedIn",
                                                       "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                        });
            }
            return "";
        }

        private string UnknownError()
        {
            return
                JsonExtensionsWeb.ToJson(new PasswordResponse()
                    {
                        isBad = true,
                        msg =
                            Localization.GetString("txtMessage.UnknownException",
                                                   "~/DesktopModules/InspectorIT/PasswordReset/App_LocalResources/PasswordReset")
                    });
        }




        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

    }

    public class PasswordResponse
    {
        public bool isBad { get; set; }
        public string msg { get; set; }
    }
}
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
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Users;

/// <summary>
/// Class DesktopModules_InspectorIT_PasswordReset_PasswordReset
/// </summary>
public partial class DesktopModules_InspectorIT_PasswordReset_PasswordReset : PortalModuleBase
{

    /// <summary>
    /// Handles the Load event of the Page control.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="EventArgs"/> instance containing the event data.</param>
    protected void Page_Load(object sender, EventArgs e)
    {

        if (UserId > 0)
        {
            plIsLoggedIn.Visible = true;
        }
        else
        {
            plNotLoggedIn.Visible = true;
        }

        if (UserInfo.IsInRole("Administrators") || UserInfo.IsSuperUser)
        {
            plCurrentPassword.Visible = false;
            plCurrentUser.Visible = true;

        }
    }

    /// <summary>
    /// Gets the selected user info.
    /// </summary>
    /// <value>The selected user info.</value>
    public UserInfo SelectedUserInfo
    {
        get
        {
            if (string.IsNullOrEmpty(Request.QueryString["SUserId"]))
            {
                return UserInfo;
            }
            else
            {
                int test = 0;
                if (int.TryParse(Request.QueryString["SUserId"], out test))
                {
                    return UserController.GetUserById(PortalId, Convert.ToInt32(Request.QueryString["SUserId"]));
                }
                else
                {
                    return UserInfo;
                }
            }
        }
    }

    /// <summary>
    /// Gets the length of the min password.
    /// </summary>
    /// <value>The length of the min password.</value>
    public int MinPasswordLength
    {
        get { return DotNetNuke.Security.Membership.MembershipProviderConfig.MinPasswordLength; }
    }

}
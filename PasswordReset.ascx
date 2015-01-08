<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PasswordReset.ascx.cs" Inherits="DesktopModules_InspectorIT_PasswordReset_PasswordReset" %>
<%@ Register TagPrefix="dnn" TagName="label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>
<dnn:DnnJsInclude ID="DnnJsInclude4" runat="server" Priority="103" FilePath="~/DesktopModules/InspectorIT/PasswordReset/js/PasswordReset.js"></dnn:DnnJsInclude>

<asp:Panel runat="server" ID="plIsLoggedIn" Visible="False">
    <div id="passwordReset">
        <!-- Message Inserted Here -->
        <div class="dnnForm dnnClear passwordResetForm">

            <asp:Label runat="server" ID="txtDescription" CssClass="summary" ResourceKey="txtDescription" Text=""></asp:Label>

            <div class="message"></div>
            <asp:Panel runat="server" ID="plCurrentPassword">
            <div class="SubHead dnnFormItem">
                <dnn:label runat="server" ID="lblCurrentPassword" ControlName="txtCurrentPassword" Text="Enter Your Current Password"></dnn:label>
                <asp:TextBox runat="server" ID="txtCurrentPassword" TextMode="Password"></asp:TextBox>
            </div>
            </asp:Panel>
            <asp:Panel runat="server" ID="plCurrentUser" Visible="False">
                <div class="SubHead dnnFormItem">
                    <dnn:label runat="server" ID="lblCurrentUser" Text="Current User"></dnn:label>
                    <div class="textValue"><%= SelectedUserInfo.DisplayName %></div>
                </div>
            </asp:Panel>

            <div class="SubHead dnnFormItem">
                <dnn:label runat="server" ID="lblNewPassword" ControlName="txtNewPassword" Text="Enter Your New Password"></dnn:label>
                <asp:TextBox runat="server" ID="txtNewPassword" TextMode="Password"></asp:TextBox>
            </div>

            <div class="SubHead dnnFormItem">
                <dnn:label runat="server" ID="lblConfirmPassword" ControlName="txtConfirmPassword" Text="Confirm Your New Password"></dnn:label>
                <asp:TextBox runat="server" ID="txtConfirmPassword" TextMode="Password"></asp:TextBox>
            </div>

            <ul class="dnnActions">
                <li><input type="button" id="btnResetPassword" class="dnnPrimaryAction" name="btnResetPassword" value="<%= Localization.GetString("btnResetPassword.Text", LocalResourceFile) %>" ResourceKey="btnResetPassword" onclick="return $.iitPasswordReset.ResetPassword()" /></li>
                <li><img id="resetPassword_ajaxLoader" style="display:none;" src="<%=ControlPath %>images/ajax-loader.gif" alt="loading..." /></li>
            </ul>
        </div>
    </div>
    
    <script type="text/javascript">
        $.iitPasswordReset.Init({
                ControlPath: '<%=ControlPath %>',
            UserId: <%=SelectedUserInfo.UserID %>,
            PasswordLength: <%=MinPasswordLength%>,
            UnknownException: '<%= Localization.GetString("txtMessage.UnknownException", LocalResourceFile) %>',
            PasswordsNotMatch: '<%= Localization.GetString("txtMessage.PasswordsNotMatch", LocalResourceFile) %>',
            PasswordTooShort: '<%= Localization.GetString("txtMessage.PasswordTooShort", LocalResourceFile) %>'
        });
    </script>

</asp:Panel>

<asp:Panel runat="server" ID="plNotLoggedIn" Visible="False">
    <p><asp:Label runat="server" ID="lblNotLoggedIn" ResourceKey="lblNotLoggedIn"></asp:Label> </p>
</asp:Panel>


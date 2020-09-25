/// Created using the page template: Default
Class CustomCubeActions.UI.Config Extends %DeepSee.UI.standardPage [ Language = objectscript ]
{

Property ChangedActions;

Property ActionCount As %Integer [ InitialExpression = 0 ];

Parameter DOMAIN = "CustomCubeActions";

Parameter Version = 1;

/// Displayed name of this page.
Parameter PAGENAME = "CustomCubeActions";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<vgroup id="contentgroup" valign="top">
</vgroup>
</pane>
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String [ Internal ]
{
	Quit $$$Text("CustomCubeActions","CustomCubeActions")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status [ Internal ]
{
	Set pDisplay=1
	Set pSearchBox=0
	Set pRibbonTitle=$$$Text("CustomCubeActions")

	// commands
	// $LB(id,caption,help,onclick)
	Set pCommands($I(cmdIdx))=$LB("cmdAdd",$$$Text("Add Action"),$$$Text("Add a new Action"),"zenPage.addAction();")
	Set pCommands($I(cmdIdx))=$LB("cmdSave",$$$Text("Save Actions"),$$$Text("Save the current state of Actions"),"zenPage.saveActions();")
	
	Quit $$$OK
}

Method OnDrawRibbon() As %Status [ Internal ]
{
	&html<<td id="ribbonSpacer" width="5%"></td>>
	&html<<td id="ribbonMessage" style="color:red" width="20%"></td>>
	Quit $$$OK
}

/// OCnvenience utility for setting the ribbon message
ClientMethod setRibbonMessage(message) [ Internal, Language = javascript ]
{
	if (message == undefined) {
		message='';
	}
	self.document.getElementById('ribbonMessage').innerHTML=message;
}

ClientMethod addAction() [ Internal, Language = javascript ]
{
    zenPage.ActionDisplay();
}

ClientMethod saveActions() [ Language = javascript ]
{
    zenPage.setRibbonMessage(this.Save());
}

Method Save(pName As %String) As %String [ ZenMethod ]
{
    Set tSC=$$$OK
	Set tMsg="Actions Saved"
	
    Set tPos=1
    While $Bitfind(..ChangedActions,tPos)'=0 {
        Set tPos=$Bitfind(..ChangedActions,tPos)

        //TODO: Find values for tPos and save new/updated Actions object

        Quit:$$$ISERR(tSC)
    }
	If $$$ISERR(tSC) {
		Set tMsg=$System.Status.GetErrorText(tSC)
	}
	
	Quit tMsg
}

Method ActionDisplay(pID = "", pName = "", pClass = "", pMethod = "") As %Status [ ZenMethod ]
{
    Set tSC=$$$OK

    Set ..ActionCount=..ActionCount+1
    Set tPane=..%GetComponentById("contentgroup")
    Set tGroup=##class(%ZEN.Component.hgroup).%New()
    Set tActionNum=##class(%ZEN.Component.hidden).%New()
    Set tActionNum.value=..ActionCount
    Set tSC=tGroup.%AddChild(tActionNum)
    Set tID=##class(%ZEN.Component.hidden).%New()
    Set tID.value=pID
    Set tSC=tGroup.%AddChild(tID)
    Set tName=##class(%ZEN.Component.text).%New()
    Set tName.label="Name:"
    Set tName.value=pName
    Set tSC=tGroup.%AddChild(tName)
    Set tClass=##class(%ZEN.Component.text).%New()
    Set tClass.label="Class:"
    Set tClass.value=pClass
    Set tSC=tGroup.%AddChild(tClass)
    Set tMethod=##class(%ZEN.Component.text).%New()
    Set tMethod.label="Method:"
    Set tMethod.value=pMethod
    Set tSC=tGroup.%AddChild(tMethod)
    Set tSC=tPane.%AddChild(tGroup)

    Quit tSC
}

/// Apply changes to page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC=##super()
	If $$$ISERR(tSC) Quit tSC
    
    Set tSQL="SELECT ID,Name,Class,Method FROM CustomCubeActions.Actions"
    Set tSQLRS=##class(%SQL.Statement).%ExecDirect(,tSQL)

    While tSQLRS.%Next() {
        Set tSC=..ActionDisplay(tSQLRS.ID,tSQLRS.Name,tSQLRS.Class,tSQLRS.Method)
    }
	
	Quit $$$OK
}

}

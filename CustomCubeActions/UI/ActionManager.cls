/// Created using the page template: Default
Class CustomCubeActions.UI.ActionManager Extends %DeepSee.UI.standardPage [ Language = objectscript ]
{

Property ActionCount As %Integer [ InitialExpression = 0 ];

Parameter DOMAIN = "CustomCubeActions";

Parameter Version = 1;

/// Displayed name of this page.
Parameter PAGENAME = "Action Manager";

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
	Quit $$$Text("Action Manager","CustomCubeActions")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status [ Internal ]
{
	Set pDisplay=1
	Set pSearchBox=0
	Set pRibbonTitle=$$$Text("Action Manager")

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
	
    Set tContentGroup=..%GetComponentById("contentgroup")
    For i=1:1:tContentGroup.children.Count() {
        If tContentGroup.children.GetAt(i).%IsA("%ZEN.Component.spacer") {
            Continue
        }
        Set tChanged=tContentGroup.children.GetAt(i).children.GetAt(1).value
        If tChanged {
            Set tID=tContentGroup.children.GetAt(i).children.GetAt(2).value
            Set tName=tContentGroup.children.GetAt(i).children.GetAt(3).value
            Set tClass=tContentGroup.children.GetAt(i).children.GetAt(4).value
            Set tMethod=tContentGroup.children.GetAt(i).children.GetAt(5).value
            Set tCubes=tContentGroup.children.GetAt(i).children.GetAt(6).value
            
            If (tName="")||(tClass="")||(tMethod="") {
                If tID'="" {
                    Set tSC=##class(CustomCubeActions.Actions).%DeleteId(tID)
                }
            } Else {
                If tID="" {
                    Set tSC=##class(CustomCubeActions.Actions).AddAction(tName,tClass,tMethod,tCubes)
                } Else {
                    Set tSC=##class(CustomCubeActions.Actions).UpdateAction(tID,tName,tClass,tMethod,tCubes)
                }
            }
            Quit:$$$ISERR(tSC)
        }
        Quit:$$$ISERR(tSC)
    }
	If $$$ISERR(tSC) {
		Set tMsg=$System.Status.GetErrorText(tSC)
	}
	
	Quit tMsg
}

Method ActionDisplay(pID = "", pName = "", pClass = "", pMethod = "", pCubes = "") As %Status [ ZenMethod ]
{
    Set tSC=$$$OK

    Set ..ActionCount=..ActionCount+1
    Set tPane=..%GetComponentById("contentgroup")
    Set tGroup=##class(%ZEN.Component.hgroup).%New()
    Set tChanged=##class(%ZEN.Component.hidden).%New()
    Set tChanged.id="Changed"_..ActionCount
    Set tChanged.value=0
    Set tSC=tGroup.%AddChild(tChanged)
    Set tID=##class(%ZEN.Component.hidden).%New()
    Set tID.value=pID
    Set tSC=tGroup.%AddChild(tID)
    Set tName=##class(%ZEN.Component.text).%New()
    Set tName.label="Action Name:"
    Set tName.value=pName
    Set tName.onchange="zen('Changed"_..ActionCount_"').setValue(1);"
    Set tSC=tGroup.%AddChild(tName)
    Set tClass=##class(%ZEN.Component.text).%New()
    Set tClass.label="Class:"
    Set tClass.value=pClass
    Set tClass.size=30
    Set tClass.onchange="zen('Changed"_..ActionCount_"').setValue(1);"
    Set tSC=tGroup.%AddChild(tClass)
    Set tMethod=##class(%ZEN.Component.text).%New()
    Set tMethod.label="Method:"
    Set tMethod.value=pMethod
    Set tMethod.onchange="zen('Changed"_..ActionCount_"').setValue(1);"
    Set tSC=tGroup.%AddChild(tMethod)
    Set tCubes=##class(%ZEN.Component.text).%New()
    Set tCubes.label="Cubes:"
    Set tCubes.title="Comma separated list of cubes that this action is available for. ""All"" can be used for all cubes."
    Set tCubes.value=pCubes
    Set tCubes.onchange="zen('Changed"_..ActionCount_"').setValue(1);"
    Set tSC=tGroup.%AddChild(tCubes)
    Set tSC=tPane.%AddChild(tGroup)
    Set tSpacer=##class(%ZEN.Component.spacer).%New()
    Set tSpacer.height="10px"
    Set tSC=tPane.%AddChild(tSpacer)

    Quit tSC
}

/// Apply changes to page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC=##super()
	If $$$ISERR(tSC) Quit tSC
    
    Set tSQL="SELECT ID,Name,Class,Method,Cubes FROM CustomCubeActions.Actions"
    Set tSQLRS=##class(%SQL.Statement).%ExecDirect(,tSQL)

    While tSQLRS.%Next() {
        Set tSC=..ActionDisplay(tSQLRS.ID,tSQLRS.Name,tSQLRS.Class,tSQLRS.Method,$ListToString(tSQLRS.Cubes))
    }
	
	Quit $$$OK
}

}

/// Created using the page template: Default
Class CustomCubeActions.UI.ActionClassManager Extends %DeepSee.UI.standardPage [ Language = objectscript ]
{

Property CubeCount As %Integer [ InitialExpression = 0 ];

Parameter DOMAIN = "CustomCubeActions";

Parameter Version = 1;

/// Displayed name of this page.
Parameter PAGENAME = "Action Class Manager";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
</style>
}

XData contentPane [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen">
<vgroup id="assignedcubes" label="Cubes with Action Class" valign="top">
</vgroup>
<spacer height="50px"/>
<vgroup id="unassignedcubes" label="Cubes without Action Class" valign="top">
</vgroup>
</pane>
}

/// Get the (localized) name of the page.
Method %OnGetPageName() As %String [ Internal ]
{
	Quit $$$Text("Action Class Manager","CustomCubeActions")
}

/// Get information to display in the ribbon bar.
Method OnGetRibbonInfo(Output pDisplay As %Boolean, Output pViewIcons As %List, Output pSortOptions As %List, Output pSearchBox As %Boolean, Output pRibbonTitle As %String, Output pCommands As %List) As %Status [ Internal ]
{
	Set pDisplay=1
	Set pSearchBox=0
	Set pRibbonTitle=$$$Text("Action Class Manager")

	// commands
	// $LB(id,caption,help,onclick)
	Set pCommands($I(cmdIdx))=$LB("cmdSave",$$$Text("Save Action Classes"),$$$Text("Save the current state of Action Classes"),"zenPage.saveActionClasses();")
	
	Quit $$$OK
}

Method OnDrawRibbon() As %Status [ Internal ]
{
	&html<<td id="ribbonSpacer" width="5%"></td>>
	&html<<td id="ribbonMessage" style="color:red" width="20%"></td>>
	Quit $$$OK
}

/// Convenience utility for setting the ribbon message
ClientMethod setRibbonMessage(message) [ Internal, Language = javascript ]
{
	if (message == undefined) {
		message='';
	}
	self.document.getElementById('ribbonMessage').innerHTML=message;
}

ClientMethod saveActionClasses() [ Language = javascript ]
{
    zenPage.setRibbonMessage("Saving Action Classes...");
    zenPage.setRibbonMessage(this.Save());
}

Method Save(pName As %String) As %String [ ZenMethod ]
{
    Set tSC=$$$OK
	Set tMsg="Action Classes Saved"
	
    For tGroup="assignedcubes","unassignedcubes" {
        Set tContentGroup=..%GetComponentById(tGroup)
        For i=1:1:tContentGroup.children.Count() {
            Set tChanged=tContentGroup.children.GetAt(i).children.GetAt(1).value
            If tChanged {
                Set tCube=tContentGroup.children.GetAt(i).children.GetAt(2).label
                Set tActionClass=tContentGroup.children.GetAt(i).children.GetAt(2).value
                Set tCubeClass=##class(%DeepSee.Utils).%GetCubeClass(tCube)

                Set tModel=##class(%DeepSee.Utils).%GetModel(tCube)
                Set tModel.actionClass=tActionClass

                Set tSC=##class(%DeepSee.Utils).%SaveCubeDefinition(tCubeClass,,tModel.description,tModel)
	            Quit:$$$ISERR(tSC)
                Set tSC=$System.OBJ.Compile(tCubeClass,"fck /displayerror=0 /displaylog=0")
                Quit:$$$ISERR(tSC)
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

Method CubeDisplay(pCube = "", pActionClass = "") As %Status [ ZenMethod ]
{
    Set tSC=$$$OK

    Set ..CubeCount=..CubeCount+1
    Set tGroup="assignedcubes"
    If pActionClass="" {
        Set tGroup="unassignedcubes"
    }
    Set tPane=..%GetComponentById(tGroup)
    Set tGroup=##class(%ZEN.Component.hgroup).%New()
    Set tChanged=##class(%ZEN.Component.hidden).%New()
    Set tChanged.id="Changed"_..CubeCount
    Set tChanged.value=0
    Set tSC=tGroup.%AddChild(tChanged)
    Set tCube=##class(%ZEN.Component.text).%New()
    Set tCube.label=pCube
    Set tCube.value=pActionClass
    Set tCube.size=50
    Set tCube.onchange="zen('Changed"_..CubeCount_"').setValue(1);"
    Set tSC=tGroup.%AddChild(tCube)

    // If pActionClass is empty or does not contain "CustomCubeActions.ActionClass", display "Generate Action Class" button
    If (pActionClass="")||(pActionClass'["CustomCubeActions.ActionClass") {
        Set tButton=##class(%ZEN.Component.button).%New()
        Set tButton.caption="Generate Action Class"
        Set tButton.onclick="zenPage.generateClicked('"_pCube_"');"
        // Generate is not fully developed yet
        //Set tSC=tGroup.%AddChild(tButton)
    }

    // If pActionClass is defined and does not contain "CustomCubeActions.ActionClass", display "unmanaged" warning
    If (pActionClass'="")&&(pActionClass'["CustomCubeActions.ActionClass") {
        // TODO: Add warning message
    }

    Set tSC=tPane.%AddChild(tGroup)

    Quit tSC
}

Method GenerateClicked(pCube) As %Status [ ZenMethod ]
{
    Set tSC=$$$OK

    // Generate Class
    // Assign value
    // Save page

    Quit tSC
}

/// Apply changes to page.
Method %OnAfterCreatePage() As %Status
{
	Set tSC=##super()
	If $$$ISERR(tSC) Quit tSC
    
    Set tSC=##class(CustomCubeActions.Utils).GetCubes(1,.tCubes)
    Set tCube=$Order(tCubes(""))
    While tCube'="" {
        Set tSC=..CubeDisplay(tCube,tCubes(tCube))
        Set tCube=$Order(tCubes(tCube))
    }
    
    Set tSC=##class(CustomCubeActions.Utils).GetCubes(0,.tCubes)
    Set tCube=$Order(tCubes(""))
    While tCube'="" {
        Set tSC=..CubeDisplay(tCube,tCubes(tCube))
        Set tCube=$Order(tCubes(tCube))
    }
	
	Quit $$$OK
}

}

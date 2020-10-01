Class CustomCubeActions.Utils
{

ClassMethod GetCubes(pHasActionClass As %Boolean, pCubeList) As %Status
{
    Set tSC=$$$OK

    Kill pCubeList
    // Can't directly modify subject area (inherited from base cube), only list cubes
    Set tSC=##class(%DeepSee.Utils).%GetCubeList(.tList,"cubes",1)

    Set tCube=$Order(tList(""))
    While tCube'="" {
        Set tCubeName=$LG(tList(tCube),1)
        Set tActionClass=##class(%DeepSee.Utils).%GetCubeActionClass(tCube)
        If pHasActionClass&&(tActionClass'="") {
            Set pCubeList(tCubeName)=tActionClass
        } ElseIf 'pHasActionClass&&(tActionClass="") {
            Set pCubeList(tCubeName)=tActionClass
        }
        Set tCube=$Order(tList(tCube))
    }

    Quit tSC
}

ClassMethod GenerateActionClass(pCube As %String = "") As %Status
{
    Set tSC=$$$OK

    If pCube="" {
        Set tSC=$$$ERROR(5001,"Cube required")
        Return tSC
    }

    Set tTemplate=##class(%Dictionary.ClassDefinition).%OpenId("CustomCubeActions.ActionClass")
    Set tClass=tTemplate.%ConstructClone()
	Set tClass.Name="CustomCubeActions.ActionClass."_pCube
	Set tClass.Super="CustomCubeActions.ActionClass"
	Set tSC=tClass.%Save()
    Quit:$$$ISERR(tSC) tSC

    // This compile throws an error, the KPI name property needs to be changed
	Do $system.OBJ.Compile(tClass.Name,"fck /displayerror=0 /displaylog=0")
    Set tSC=##class(CustomCubeActions.Utils).UpdateKPIName(pCube)
    Quit:$$$ISERR(tSC) tSC

	Set tSC=$system.OBJ.Compile(tClass.Name,"fck /displayerror=0 /displaylog=0")
    Quit:$$$ISERR(tSC) tSC
    
    Quit tSC
}

ClassMethod UpdateKPIName(pCube) As %Status
{
    Set tSC=$$$OK

    // Open XData block
    Set tXData = ##class(%Dictionary.XDataDefinition).IDKEYOpen("CustomCubeActions.ActionClass."_pCube,"KPI",0,.tSC)
    Quit:$$$ISERR(tSC) tSC
    If $IsObject(tXData) {
        Do tXData.Data.Rewind()
        // Read data into stream
        Set tText=tXData.Data.Read()
        // Change name from name="CustomCubeActions" to pCube_"CustomCubeActions"
        Set tText=$Replace(tText,"name=""CustomCubeActions""","name="""_pCube_"CustomCubeActions""")
    }
    // Write stream back to XData block and save
    Set tSC=tXData.Data.Write(tText)
    Quit:$$$ISERR(tSC) tSC
    Set tSC=tXData.%Save()
    Quit:$$$ISERR(tSC) tSC

    Quit tSC
}

ClassMethod UpdateActionClass(pCube, pActionClass) As %Status
{
    Set tSC=$$$OK

    Set tCubeClass=##class(%DeepSee.Utils).%GetCubeClass(pCube)

    Set tModel=##class(%DeepSee.Utils).%GetModel(pCube)
    Set tModel.actionClass=pActionClass

    Set tSC=##class(%DeepSee.Utils).%SaveCubeDefinition(tCubeClass,,tModel.description,tModel)
    Quit:$$$ISERR(tSC) tSC
    Set tSC=$System.OBJ.Compile(tCubeClass,"fck /displayerror=0 /displaylog=0")
    Quit:$$$ISERR(tSC) tSC

    Quit tSC
}

}

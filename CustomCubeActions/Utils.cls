Class CustomCubeActions.Utils
{

ClassMethod GetCubes(pHasActionClass As %Boolean, pCubeList) As %Status
{
    Set tSC=$$$OK

    Kill pCubeList
    Set tSC=##class(%DeepSee.Utils).%GetCubeList(.tList,,1)

    Set tCube=$Order(tList(""))
    While tCube'="" {
        Set tActionClass=##class(%DeepSee.Utils).%GetCubeActionClass(tCube)
        If pHasActionClass&&(tActionClass'="") {
            Set pCubeList(tCube)=tActionClass
        } ElseIf 'pHasActionClass&&(tActionClass="") {
            Set pCubeList(tCube)=tActionClass
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

    Set tClass=##class(%Dictionary.ClassDefinition).%New()
	Set tClass.Name="CustomCubeActions.ActionClass."_pCube
	Set tClass.Super="CustomCubeActions.ActionClass"
	Set tSC=tClass.%Save()
    Quit:$$$ISERR(tSC) tSC
    // TODO: This compile throws an error, the KPI name property needs to be changed
	Set tSC=$system.OBJ.Compile(tClass.Name,"fck /displayerror=0 /displaylog=0")
    Quit:$$$ISERR(tSC) tSC
    
    Quit tSC
}

}

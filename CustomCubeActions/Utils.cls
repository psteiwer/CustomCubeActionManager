Class CustomCubeActions.Utils
{

ClassMethod GetCubes(pHasActionClass As %Boolean, pCubeList) As %Status
{
    Set tSC=$$$OK

    Kill pCubeList
    Set tSC=##class(%DeepSee.Utils).%GetCubeList(.tList)

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

}

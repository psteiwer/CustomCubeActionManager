/// CustomCubeActions.ActionClass
Class CustomCubeActions.ActionClass Extends %DeepSee.KPI [ Language = objectscript ]
{

XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi
xmlns="http://www.intersystems.com/deepsee/kpi"
 name="CustomCubeActions">
</kpi>
}

ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status
{
	Set tSC=$$$OK

	Set tCube=$Piece(pAction,":",1)
	Set pAction=$Piece(pAction,":",2,*)
	Set tSQL="SELECT Class,Method FROM CustomCubeActions.Actions WHERE $ListFind(Cubes,?)>0 AND Name=?"
	Set tSQLRS=##class(%SQL.Statement).%ExecDirect(,tSQL,tCube,pAction)

	If tSQLRS.%Next() {
		Set tSC=$ClassMethod(tSQLRS.Class,tSQLRS.Method,pAction,pContext)
	}

	Quit tSC
}

/// pActions($I(pActions))=$LB(name,caption)<br/>
ClassMethod %OnGetActionList(ByRef pActions As %List, pDataSourceName As %String = "") As %Status
{
	Set tCube="All"
	Set tClass=$Piece(..%ClassName(1),".",3,*)
	If tClass'="" {
		Set tCube=$Replace(tClass,".","/")
	}
	
	Set tSQL="SELECT Name,Class,Method FROM CustomCubeActions.Actions WHERE $ListFind(Cubes,?)>0"
	Set tSQLRS=##class(%SQL.Statement).%ExecDirect(,tSQL,tCube)

	While tSQLRS.%Next() {
		Set pActions($I(pActions))=$LB(tCube_":"_tSQLRS.Name,tSQLRS.Name)
	}

	Quit $$$OK
}

}

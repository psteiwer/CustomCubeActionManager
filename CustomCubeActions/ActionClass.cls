/// CustomCubeActions.ActionClass
Class CustomCubeActions.ActionClass Extends %DeepSee.KPI [ Language = objectscript ]
{

Parameter Cube = {..%ClassName()};

XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi
xmlns="http://www.intersystems.com/deepsee/kpi"
 name="CustomCubeActions">
</kpi>
}

ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status
{
	// TODO: Lookup class + method for pAction and call it

	Quit $$$OK
}

/// pActions($I(pActions))=$LB(name,caption)<br/>
ClassMethod %OnGetActionList(ByRef pActions As %List, pDataSourceName As %String = "") As %Status
{
	Set tCube="All"
	If ..#Cube'="ActionClass" {
		Set tCube=..#Cube
	}
	
	// TODO: Query Actions table and populate pActions with results

	Quit $$$OK
}

}

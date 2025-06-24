Class Demo.ProductoAPI Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/producto" Method="GET" Call="Listar"/>
    <Route Url="/producto" Method="POST" Call="Crear"/>
  </Routes>
}

ClassMethod Listar() As %Status
{
   Try {
    Set productos = []
    &sql(DECLARE C1 CURSOR FOR SELECT ID, Nombre, Precio FROM Demo.Producto)
    &sql(OPEN C1)
    While (SQLCODE=0) {
      &sql(FETCH C1 INTO :id, :nombre, :precio)
      Quit:SQLCODE'=0
      Do productos.%Push({"ID": (id), "Nombre": (nombre), "Precio": (precio)})
    }

    Do ##class(%REST.Impl).%SetContentType("application/json")
    Do ##class(%REST.Impl).%SetStatusCode("200")
    Write productos.%ToJSON()
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
       Write ex.DisplayString()
    }
  Quit $$$OK
}

ClassMethod Crear() As %Status
{
  Try {
    set dynamicBody = {}.%FromJSON(%request.Content)
    Set prod = ##class(Demo.Producto).%New()
    Set prod.Nombre = dynamicBody.%Get("Nombre")
    Set prod.Precio = dynamicBody.%Get("Precio")
    Do prod.%Save()

    Do ##class(%REST.Impl).%SetContentType("application/json")
    Do ##class(%REST.Impl).%SetStatusCode("200")
    Write prod.%JSONExport()
    } Catch (ex) {
        Do ##class(%REST.Impl).%SetStatusCode("400")
       Write ex.DisplayString()
    }
    Quit $$$OK
}

}

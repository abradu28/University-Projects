package butelca.transport.repository;

import butelca.transport.model.Route;

import java.util.ArrayList;

public class RouteRepository
{
    private ArrayList<Route> routes;

    public RouteRepository()
    {
        routes = new ArrayList<>();
    }

    public void addRoute(Route r)
    {
        routes.add(r);
    }

    public void removeRoute(Route r)
    {
        routes.remove(r);
    }

    public ArrayList<Route> getRoutes() {
        return routes;
    }
}

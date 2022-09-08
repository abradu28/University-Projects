package butelca.transport.repository;

import butelca.transport.model.City;

import java.util.ArrayList;

public class CityRepository
{
    private ArrayList<City> cities;

    public CityRepository()
    {
        cities = new ArrayList<>();
    }

    public void addCity(City c)
    {
        cities.add(c);
    }

    public void removeCity(City c)
    {
        cities.remove(c);
    }
    public void removeCity(String name)
    {
        for (City c : cities)
            if (name.equals(c.getName()))
            {
                cities.remove(c);
                break;
            }
    }

    public ArrayList<City> getCities() {
        return cities;
    }
}

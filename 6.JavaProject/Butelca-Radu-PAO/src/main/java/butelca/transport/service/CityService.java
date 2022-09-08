package butelca.transport.service;

import butelca.transport.model.City;
import butelca.transport.repository.CityRepository;

import java.util.Scanner;

public class CityService
{
    CityRepository cityRepository;
    AuditService auditService;

    public CityService()
    {
        cityRepository = new CityRepository();
        auditService = AuditService.getAuditService();
    }

    public City addCity(Scanner s)
    {
        System.out.println("Enter city name: ");
        String name = s.next();

        //add city only if the name is unique
        if(getCityByName(name)!=null)
            return null;

        System.out.println("Enter city longitude: ");
        float longitude = s.nextFloat();

        System.out.println("Enter city lattitude: ");
        float lattitude = s.nextFloat();

        City c = new City(name,longitude,lattitude);
        cityRepository.addCity(c);

        auditService.logData("CityService_addCity");
        return c;
    }

    public void removeCity(Scanner s)
    {
        System.out.println("Enter city name: ");
        cityRepository.removeCity(s.next());

        auditService.logData("CityService_removeCity");


    }

    public City getCityByName(String name)
    {
        auditService.logData("CityService_getCityByName");

        for(City c : cityRepository.getCities())
        {
            if(c.getName().equals(name))
                return c;
        }
        return null;
    }

    public String allCities()
    {
        StringBuilder res = new StringBuilder();
        for(City c : cityRepository.getCities())
        {
            res.append(c.toString()).append("\n");
        }

        auditService.logData("CityService_allCities");
        return res.toString();
    }
}

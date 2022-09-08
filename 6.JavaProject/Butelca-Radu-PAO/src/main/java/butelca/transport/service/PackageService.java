package butelca.transport.service;

import butelca.transport.main.Main;
import butelca.transport.model.City;
import butelca.transport.model.Client;
import butelca.transport.repository.PackageRepository;
import butelca.transport.model.Package;

import java.util.ArrayList;
import java.util.Scanner;

public class PackageService
{
    private PackageRepository packageRepository;
    private AuditService auditService;

    public PackageService()
    {
        packageRepository = new PackageRepository();
        auditService = AuditService.getAuditService();
    }

    public Package addPackage(Scanner s)
    {
        System.out.println("Enter package volume: ");
        float volume = s.nextFloat();

        System.out.println("Enter package weight: ");
        float weight = s.nextFloat();

        System.out.println("Enter first city name: ");
        City c1 = Main.cityService.getCityByName(s.next());
        if(c1==null)
        {
            System.out.println("City doesn't exist!");
            return null;
        }

        System.out.println("Enter second city name: ");
        City c2 = Main.cityService.getCityByName(s.next());
        if(c2==null)
        {
            System.out.println("City doesn't exist!");
            return null;
        }

        System.out.println("Enter client id: ");
        Client client = Main.clientService.getClientById(s.nextInt());
        if(client == null)
        {
            System.out.println("Client doesn't exist!");
            return null;
        }

        Package p = new Package(packageRepository.getLastId(), volume, weight, c1, c2, client);
        packageRepository.addPackage(p);

        auditService.logData("PackageService_addPackages");
        return p;
    }

    public ArrayList<Package> getPackagesForClient(Client c)
    {
        auditService.logData("PackageService_getPackagesForClient");
        return packageRepository.getPackagesByClient(c);
    }
}

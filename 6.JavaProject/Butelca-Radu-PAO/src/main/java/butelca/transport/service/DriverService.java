package butelca.transport.service;

import butelca.transport.main.Main;
import butelca.transport.model.Car;
import butelca.transport.repository.DriverRepository;
import butelca.transport.model.Driver;

import java.util.ArrayList;
import java.util.Scanner;

public class DriverService
{
    private DriverRepository driverRepository;
    private AuditService auditService;

    public DriverService()
    {
        driverRepository = new DriverRepository();
        auditService = AuditService.getAuditService();
    }

    public Driver addDriver(Scanner s)
    {
        System.out.println("Enter first name: ");
        String firstName = s.next();

        System.out.println("Enter last name: ");
        String lastName = s.next();

        System.out.println("Enter phone number: ");
        String phoneNr = s.next();

        System.out.println("Enter car registration number('None' for none): ");
        String regNr = s.next();
        Car c = Main.carService.getCarByReg(regNr);

        System.out.println("Enter salary: ");
        float salary = s.nextFloat();

        Driver d = new Driver(driverRepository.getLastId(), firstName, lastName, phoneNr, c, salary);
        driverRepository.addDriver(d);

        auditService.logData("DriverService_addDriver");
        return d;
    }

    public void removeDriver(Scanner s)
    {
        System.out.println("Enter driver ID: ");
        driverRepository.removeDriverById(s.nextInt());

        auditService.logData("DriverService_removeDriver");
    }

    public Driver getDriverById(int id)
    {
        for(Driver d : driverRepository.getDrivers())
            if(d.getId() == id)
            {
                return d;
            }

        auditService.logData("DriverService_getDriverById");
        return null;
    }

    public ArrayList<Driver> getDriversByCar(Car c)
    {
        ArrayList<Driver> response = new ArrayList<>();
        for(Driver d : driverRepository.getDrivers())
            if(d.getCar().equals(c))
            {
                response.add(d);
            }

        auditService.logData("DriverService_getDriversByCar");
        return response;
    }

    public void giveCarToDriver(Scanner s)
    {
        System.out.println("Enter Driver id: ");
        int driverId = s.nextInt();

        System.out.println("Enter Car reg nr: ");
        Car c = Main.carService.getCarByReg(s.next());

        Driver d = getDriverById(driverId);

        if(d != null&& c != null)
            d.setCar(c);
        else
            System.out.println("Driver/Car doesn't exist! No changes made");


        auditService.logData("DriverService_giveCarToDriver");
    }

    public String allDrivers()
    {
        auditService.logData("DriverService_allDrivers");

        StringBuilder res = new StringBuilder();
        for(Driver d : driverRepository.getDrivers())
        {
            res.append(d.toString()).append("\n");
        }
        return res.toString();
    }

    public ArrayList<Driver> getDrivers()
    {
        auditService.logData("DriverService_getDrivers");
        return driverRepository.getDrivers();
    }

    public DriverRepository getDriverRepository() {
        return driverRepository;
    }
}

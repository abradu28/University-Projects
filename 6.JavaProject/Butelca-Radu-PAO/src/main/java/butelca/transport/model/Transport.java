package butelca.transport.model;

import java.util.ArrayList;
import java.util.Date;

public class Transport implements Comparable
{
    private int transportID;
    private ArrayList<Package> packages;
    private Date transportDate;
    private Driver driver;
    private Car car;

    public Transport(int transportID) {
        this.transportID = transportID;
        packages = new ArrayList<>();
        transportDate = null;
        driver = null;
        car = null;
    }

    public int getTransportID() {
        return transportID;
    }

    public ArrayList<Package> getPackages() {
        return packages;
    }

    public Date getTransportDate() {
        return transportDate;
    }

    public Driver getDriver() {
        return driver;
    }

    public Car getCar() {
        return car;
    }

    //function takes driver and sets also the car to car of driver
    public void setDriverAndCar(Driver d)
    {
        if(alreadySent())
        {
            System.out.println("Transport already sent, can't edit!");
            return;
        }

        if(d.getCar() == null)
        {
            System.out.println("Cant put driver with no car to transport!");
            return;
        }
        driver = d;
        car = d.getCar();
    }

    public void addPackage(Package p)
    {
        if(!alreadySent())
            packages.add(p);
    }

    //send transport if not already sent
    public void sendTransport()
    {
        if(!alreadySent())
            transportDate = new Date();
    }

    public boolean alreadySent()
    {
        return transportDate == null;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for(Package p : packages)
            sb.append(p.getPackageID()).append(" ");

        if(sb.length() == 0)
            sb.append("No packages");

        return "Transport ID: " + transportID +
                " packages: " + sb.toString() +
                " transportDate: " + (transportDate==null ? "Not sent" : transportDate) +
                " driver ID: " + (driver== null ? "No driver" : driver.getId())+
                " car: " + (car == null ? "No car" : car.getRegistrationNr()) +
                " route: " + (car == null ? "No route" : car.getRoute());
    }

    @Override
    public int compareTo(Object o) {
        Transport t = (Transport) o;
        return transportDate.compareTo(t.transportDate);
    }
}

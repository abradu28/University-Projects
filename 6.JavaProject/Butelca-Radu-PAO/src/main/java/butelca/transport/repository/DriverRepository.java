package butelca.transport.repository;

import butelca.transport.model.Driver;

import java.util.ArrayList;

public class DriverRepository
{
    private int lastId;
    private ArrayList<Driver> drivers;

    public DriverRepository()
    {
        drivers = new ArrayList<>();
        lastId =0;
    }

    public DriverRepository(ArrayList<Driver> drivers) {
        this.drivers = drivers;
    }

    public void addDriver(Driver d)
    {
        drivers.add(d);
        lastId +=1;
    }

    public int getLastId()
    {
        return lastId;
    }

    public void removeDriver(Driver d)
    {
        drivers.remove(d);
    }
    public void removeDriverById(int id)
    {
        for(Driver d : drivers)
            if(d.getId() == id)
            {
                drivers.remove(d);
                break;
            }
    }

    public ArrayList<Driver> getDrivers() {
        return drivers;
    }
}

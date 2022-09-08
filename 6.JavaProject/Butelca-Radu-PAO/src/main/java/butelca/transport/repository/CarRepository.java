package butelca.transport.repository;

import butelca.transport.main.Main;
import butelca.transport.model.Car;

import java.util.ArrayList;
import java.util.TreeSet;

public class CarRepository
{
    private TreeSet<Car> cars;

    public CarRepository() {
        cars = new TreeSet<>();
    }

    public CarRepository(ArrayList<Car> cars) {
        this.cars = new TreeSet<>(cars);
    }

    public void addCar(Car c)
    {
        cars.add(c);
    }

    public void removeCar(Car c)
    {
        cars.remove(c);
    }
    public Boolean removeCar(String re)
    {
        Car toDel = null;
        for(Car c : cars)
            if (re.equals(c.getRegistrationNr()))
            {
                toDel = c;
                break;
            }

        if(toDel == null)
            return true;
        if(Main.driverService.getDriversByCar(toDel).isEmpty())
        {
            cars.remove(toDel);
            return true;
        }

        return false;
    }

    public ArrayList<Car> getCars() {
        return new ArrayList<>(cars);
    }
}

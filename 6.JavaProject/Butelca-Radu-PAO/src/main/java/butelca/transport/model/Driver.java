package butelca.transport.model;

public class Driver extends Person
{
    private Car car;
    private float salary;

    public Driver(int id, String firstName, String lastName, String phoneNumber, Car car, float salary) {
        super(id, firstName, lastName, phoneNumber);
        this.car = car;
        this.salary = salary;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    public float getSalary() {
        return salary;
    }

    public void setSalary(float salary) {
        this.salary = salary;
    }

    @Override
    public String toString() {
        return "Driver " + super.toString() +
                " car: " + (car !=null ? car.getRegistrationNr() : "No car assigned") +
                " salary: " + salary;
    }
}

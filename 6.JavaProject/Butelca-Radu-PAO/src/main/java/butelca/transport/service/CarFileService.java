package butelca.transport.service;

import butelca.transport.model.Car;
import butelca.transport.model.FileService;
import butelca.transport.repository.CarRepository;

import java.io.*;

public class CarFileService implements FileService
{
    static CarFileService carFileService;

    private CarRepository carRepository;

    private CarFileService(CarRepository cr) {
        carRepository = cr;
    }

    public void loadData()
    {
        try{
            File f = new File("car_data.csv");

            //Check if file is new
            if(!f.exists())
                return;

            BufferedReader input = new BufferedReader(new FileReader(f));

            String line;
            while((line = input.readLine()) != null)
            {
                String[] values = line.split(",");
                Car c = new Car(values[0],Float.parseFloat(values[1]),null);
                carRepository.addCar(c);
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public void saveData()
    {
        try{
            File f = new File("car_data.csv");

            BufferedWriter output = new BufferedWriter(new FileWriter(f));

            for(Car c : carRepository.getCars())
            {
                output.write(c.getRegistrationNr());
                output.write(",");
                output.write(Float.toString(c.getVolume()));
                output.write(",");
                //output.write(c.getRegistrationNr());
                output.write("NULL");
                output.newLine();
                output.flush();
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public static CarFileService getFileService(CarRepository carRepository)
    {
        if(carFileService == null)
        {
            carFileService = new CarFileService(carRepository);
        }

        return carFileService;
    }
}

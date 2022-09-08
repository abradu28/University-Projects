package butelca.transport.main;

import butelca.transport.model.*;
import butelca.transport.model.Driver;
import butelca.transport.model.Package;
import butelca.transport.service.*;
import butelca.transport.model.*;
import butelca.transport.service.*;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

public class Main
{
    public static CarService carService;
    public static ClientService clientService;
    public static CityService cityService;
    public static DriverService driverService;
    public static LinkService linkService;
    public static PackageService packageService;
    public static TransportService transportService;

    public static CarFileService carFileService;
    public static ClientFileService clientFileService;
    public static DriverFileService driverFileService;

    private static void menuLoop() {
        Scanner scanner = new Scanner(System.in);


        String DATABASE_URL = "jdbc:mysql://localhost:3306/Transport";
        String DATABASE_USER = "root";
        String DATABASE_PASSWORD = "";
        try (Connection connection = DriverManager.getConnection(DATABASE_URL, DATABASE_USER, DATABASE_PASSWORD)) {



            //0 - main menu
            int menuLocation = 0;
            int input;
            Scanner in = new Scanner(System.in);
            while (true) {
                //Main menu
                if (menuLocation == 0) {
                    System.out.println("--Main Menu--");
                    System.out.println("Options:");
                    System.out.println("1-Cars");
                    System.out.println("2-Cities");
                    System.out.println("3-Person");
                    System.out.println("4-Links");
                    System.out.println("0-Exit");

                    //Read input
                    menuLocation = scanner.nextInt();

                    if (menuLocation == 0) {
                        break;
                    }
                } else if (menuLocation == 1)      //Cars
                {
                    System.out.println("--Cars Menu--");
                    System.out.println("1-Add Car");
                    System.out.println("2-Remove Car");
                    System.out.println("3-Update Car Volume");
                    System.out.println("4-See all cars");
                    System.out.println("0-Back");

                    input = scanner.nextInt();

                    if (input == 1) {
                        //carService.addCar(scanner);
                        //Scanner in = new Scanner(System.in);
                        System.out.print("Choose a registration number: ");
                        String name = in.nextLine();
                        System.out.print("Enter volume: ");
                        float number = in.nextFloat();
                        in.nextLine();
                        System.out.print("Ruta: ");
                        String ruta = in.nextLine();
                        in.nextLine();

                        addTransport(connection, name, number, ruta);
                    } else if (input == 2) {
                        //carService.removeCar(scanner);

                        System.out.print("Choose a registration number to delete: ");
                        String name = in.nextLine();
                        deleteCar(connection, name);



                    } else if (input == 4) {
                       // System.out.println(carService.allCars());

                        getCar(connection);
                    } else if(input == 3){
                        System.out.println("Choose registrationNr: ");
                        String reg = in.nextLine();
                        System.out.println("Chosee new volume: ");
                        Float vol = in.nextFloat();
                        in.nextLine();

                        updateCarVolume(connection, reg, vol);
                    }

                     else if (input == 0)
                        menuLocation = 0;
                } else if (menuLocation == 2)      //City
                {
                    System.out.println("--City Menu--");
                    System.out.println("1-Add City");
                    System.out.println("2-Remove City");
                    System.out.println("3-Update city longitudine");
                    System.out.println("4-See all cities");
                    System.out.println("0-Back");

                    input = scanner.nextInt();

                    if (input == 1) {
                        //cityService.addCity(scanner);

                        System.out.print("Enter name: ");
                        String name = in.nextLine();
                        System.out.print("Longitudinea: ");

                        Float longitudine = in.nextFloat();
                        in.nextLine();
                        System.out.print("Latitudine: ");
                        Float latitudine = in.nextFloat();
                        in.nextLine();
                        addCity(connection, name, longitudine, latitudine);
                    } else if (input == 2) {
                        //cityService.removeCity(scanner);
                        System.out.print("Chosee which city to delete: ");
                        int Id = in.nextInt();
                        in.nextLine();
                        deleteCity(connection, Id);

                    } else if (input == 4) {
                        //System.out.println(cityService.allCities());
                        getCity(connection);
                    } else if(input == 3){
                        System.out.println("Choose idCity: ");
                        int id = in.nextInt();
                        in.nextLine();
                        System.out.println("Choose next longitudine: ");
                        Float longitudine = in.nextFloat();
                        in.nextLine();

                        updateCityLongitudine(connection, id, longitudine);
                    }
                    else if (input == 0)
                        menuLocation = 0;
                } else if (menuLocation == 3)      //Person
                {
                    System.out.println("--Clients Menu--");
                    System.out.println("1-Add Person");
                    System.out.println("2-Remove Person");
                    System.out.println("3-Update person phone number");
                    System.out.println("4-See all person");
                    System.out.println("0-Back");

                    input = scanner.nextInt();

                    if (input == 1) {
                        //clientService.addClient(scanner);

                        System.out.print("First name: ");
                        String firstName = in.nextLine();
                        System.out.print("Last name: ");
                        String lastName = in.nextLine();
                        System.out.print("Phone number: ");
                        String phoneNumber = in.nextLine();

                        addPerson(connection, firstName, lastName, phoneNumber);
                    } else if (input == 2) {
                        //clientService.removeClient(scanner);
                        System.out.print("Chosee which person to delete: ");
                        int Id = in.nextInt();
                        in.nextLine();
                        deletePerson(connection, Id);
                    } else if (input == 4) {
                      //  System.out.println(clientService.allClients());
                        getPerson(connection);
                    } else if(input == 3){
                        System.out.println("Choose idPerson: ");
                        int id = in.nextInt();
                        in.nextLine();
                        System.out.println("Choose next phone number: ");
                        String phoneNumber = in.nextLine();

                        updatePersonPhoneNumber(connection, id, phoneNumber);
                    }
                    else if (input == 0)
                        menuLocation = 0;
                }
                else if(menuLocation == 4)      //Links
                {
                    System.out.println("--Links Menu--");
                    System.out.println("1-Add Link");
                    System.out.println("2-Remove Link");
                    System.out.println("3-Shortest link between two cities");
                    System.out.println("4-See all links");
                    System.out.println("5-Update second city");
                    System.out.println("0-Back");

                    input = scanner.nextInt();

                    if(input == 1)
                    {
                     //   linkService.addLink(scanner);
                        System.out.print("City1:  ");
                        String city1 = in.nextLine();
                        System.out.print("City2: ");
                        String city2 = in.nextLine();
                        System.out.print("Lungime: ");
                        Float lungime = in.nextFloat();
                        in.nextLine();
                        System.out.print("Durata: ");
                        Float durata = in.nextFloat();
                        in.nextLine();

                        addLink(connection, city1, city2, lungime, durata);
                    }
                    else if(input == 2)
                    {
                        System.out.println("Choose which link to delete: ");
                       // linkService.removeLinkById(scanner.nextInt());
                        int Id = in.nextInt();
                        in.nextLine();
                        deleteLink(connection, Id);
                    }
                    else if(input == 3)
                    {
                        System.out.println("Enter first city name: ");
                        City c1 = cityService.getCityByName(scanner.next());

                        System.out.println("Enter second city name: ");
                        City c2 = cityService.getCityByName(scanner.next());

                        System.out.println("1-By distance\n2-By time");
                        int n = scanner.nextInt();

                        System.out.println(linkService.getShortestLink(c1,c2,n==2));

                    }
                    else if (input == 4)
                    {
                        //System.out.println(linkService.allLinks());
                        getLink(connection);
                    }
                    else if(input == 5){
                        System.out.println("Choose id Link: ");
                        int id = in.nextInt();
                        in.nextLine();
                        System.out.println("Choose next second city: ");
                        String city2 = in.nextLine();

                        updateLinkCity2(connection, id, city2);
                    }
                    else if(input == 0)
                        menuLocation = 0;
                }
            }

            close();

        }
        catch (
                SQLException ex) {
            ex.printStackTrace();
        }
    }




    private static void loadData()
    {
        carFileService.loadData();
        clientFileService.loadData();
        driverFileService.loadData();
    }

    private static void close()
    {
        carFileService.saveData();
        clientFileService.saveData();
        driverFileService.saveData();
    }

    private static void addTransport(Connection connection, String reg, float volum, String ruta) throws SQLException {

        String query = "Insert into car values(?,?,?)";

        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setString(1, reg);
        preparedStatement.setFloat(2,volum);
        preparedStatement.setString(3, ruta);

        preparedStatement.executeUpdate();
    }

    private static void addCity(Connection connection, String name, float longitudine, float latitudine)throws SQLException{
        String query = "Insert into city values(null, ?, ?, ?)";
        PreparedStatement preparedStatement = connection.prepareStatement(query);


        preparedStatement.setString(1, name);
        preparedStatement.setFloat(2, longitudine);
        preparedStatement.setFloat(3, latitudine);

        preparedStatement.executeUpdate();

    }

    private static void addPerson(Connection connection, String firstName, String lastName, String phoneNumber) throws SQLException{
        String query = "Insert into person values(null, ?, ?, ?)";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setString(1, firstName);
        preparedStatement.setString(2, lastName);
        preparedStatement.setString(3, phoneNumber);

        preparedStatement.executeUpdate();
    }

    private static void addLink(Connection connection, String city1, String city2, float length, float duration) throws SQLException{

        String query = "Insert into link values(null, ?, ?, ?, ?)";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setString(1, city1);
        preparedStatement.setString(2, city2);
        preparedStatement.setFloat(3, length);
        preparedStatement.setFloat(4, duration);

        preparedStatement.executeUpdate();

    }

    private static void deleteCar(Connection connection, String Id) throws  SQLException{
        String query = "delete from car where registrationNr = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setString(1,Id);
        preparedStatement.executeUpdate();

    }

    private static void deleteCity(Connection connection, int Id) throws  SQLException{
        String query = "delete from city where idCity = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setInt(1,Id);
        preparedStatement.executeUpdate();

    }


    private static void deletePerson(Connection connection, int Id) throws  SQLException{
        String query = "delete from person where idPerson = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setInt(1,Id);
        preparedStatement.executeUpdate();

    }

    private static void deleteLink(Connection connection, int Id) throws  SQLException{
        String query = "delete from link where idLink = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);

        preparedStatement.setInt(1,Id);
        preparedStatement.executeUpdate();

    }

    private static void getCar(Connection connection)throws SQLException{

        String query = "Select * from Car";
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while(rs.next()){
            String id = rs.getString("registrationNr");
            Float volume = rs.getFloat("Volume");
            String route  = rs.getString("Route");

            System.out.println("Id Car = " + id + ", Volum = " + volume + ", route = " + route + "\n");
        }

    }

    private static void getCity(Connection connection)throws SQLException{

        String query = "Select * from City";
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while(rs.next()){
            int id = rs.getInt("idCity");
            String name = rs.getString("name");
            float longitudine  = rs.getFloat("Longitudine");
            float latitudine = rs.getFloat("Latitudine");

            System.out.println("Id City = " + id + ", Nume = " + name + ", longitudine = " + longitudine + ", latitudine = " + latitudine + "\n");
        }

    }

    private static void getPerson(Connection connection)throws SQLException{

        String query = "Select * from Person";
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while(rs.next()){
            int id = rs.getInt("idPerson");
            String firstName = rs.getString("firstName");
            String lastName = rs.getString("lastName");
            String phoneNumber = rs.getString("phoneNumber");
            System.out.println("Id Person = " + id + ", First name = " + firstName + ", Last name = " + lastName + ", Phone number = " + phoneNumber + "\n");

        }

    }

    private static void getLink(Connection connection)throws SQLException{

        String query = "Select * from Link";
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while(rs.next()){
            int id = rs.getInt("idLink");
            String city1 = rs.getString("city1");
            String city2 = rs.getString("city2");
            Float length = rs.getFloat("length");
            Float duration = rs.getFloat("duration");
            System.out.println("Id Link = " + id + ", City1 = " + city1 + ", City2 = " + city2 + ", Length = " + length + " Duration = " + duration + "\n");

        }

    }

    private static void updateCarVolume(Connection connection, String registrationNr, Float volume) throws SQLException{

        String query = "update car set volume = ? where registrationNr = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setFloat(1, volume);
        preparedStatement.setString(2, registrationNr);
        preparedStatement.executeUpdate();

    }

    private static void updateCityLongitudine(Connection connection, int id, Float longitudine) throws SQLException{

        String query = "update city set longitudine = ? where idCity = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setFloat(1, longitudine);
        preparedStatement.setInt(2, id);
        preparedStatement.executeUpdate();

    }

    private static void updatePersonPhoneNumber(Connection connection, int id, String phoneNumber) throws SQLException{

        String query = "update person set phoneNumber = ? where idPerson = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, phoneNumber);
        preparedStatement.setInt(2, id);
        preparedStatement.executeUpdate();

    }

    private static void updateLinkCity2(Connection connection, int id, String city2) throws SQLException{

        String query = "update link set city2 = ? where idLink = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setString(1, city2);
        preparedStatement.setInt(2, id);
        preparedStatement.executeUpdate();

    }

    public static void main(String[] args)
    {
        //create services
        carService = new CarService();
        clientService = new ClientService();
        cityService = new CityService();
        driverService = new DriverService();
        linkService = new LinkService();
        packageService = new PackageService();
        transportService = new TransportService();

        //get file services
        carFileService = CarFileService.getFileService(carService.getCarRepository());
        clientFileService = ClientFileService.getFileService(clientService.getClientRepository());
        driverFileService = DriverFileService.getFileService(driverService.getDriverRepository());

        //load Saved data
        loadData();

        //start application
        menuLoop();


    }

}

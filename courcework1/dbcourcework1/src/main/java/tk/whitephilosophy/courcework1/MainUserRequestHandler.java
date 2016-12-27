package tk.whitephilosophy.courcework1;

import java.security.InvalidParameterException;
import java.sql.*;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by kirill on 12/10/16.
 */
public class MainUserRequestHandler implements UserRequestHandler{

    private final DatabaseManager _dManager;

    MainUserRequestHandler (DatabaseManager dm) { _dManager = dm; }

    private String processResSet(ResultSet rs) throws SQLException {
        String result = "";
        List<List<String>> rowList = new LinkedList<>();
        ResultSetMetaData md = rs.getMetaData();
        int c = 0;
        while (rs.next()) {
            ++c;
            List<String> columnList = new LinkedList<>();
            rowList.add(columnList);
            for (int column = 1; column <= md.getColumnCount(); column++) {
                Object value = rs.getObject(column);
                if (value != null)
                    columnList.add(value.toString());
            }
        }
        if (c == 0) return "Not found";
        /*
        for (int column = 1; column <= md.getColumnCount(); column++) {
            result +=  md.getColumnName(column) + "\t";
        }
        */
        result += "\n";
        for (List<String> row: rowList) {
            for (String value: row) {
                result += value + "\t";
            }
            result += "\n";
        }
        return result;
    }

    @Override
    public void handleUserRequest(String command, String subject, String[] params) {
        switch (command) {
            case "create":
                switch (subject) {
                    case "order":
                        if (params.length < 1) {
                            System.out.println("USAGE: App " + command + " " + subject + " args");
                            System.exit(1);
                        }
                        try {
                            _dManager.addOrder(params);
                        } catch (SQLException e) {
                            System.out.println(e.toString());
                            System.exit(1);
                        } catch (InvalidParameterException e) {
                            System.out.println("USAGE: App " + command + " " + subject + " firstname middlename lastname address country phone_name");
                            System.exit(1);
                        }
                        break;
                }
                break;
            case "retrieve":
                switch (subject) {
                    case "customer":
                        if (params.length != 3) {
                            System.out.println("USAGE: App " + command + " " + subject + " firstname middlename lastname");
                            System.exit(1);
                        }
                        try {
                            System.out.println(_dManager.viewCustomer(params[0], params[1], params[2], this::processResSet));
                        } catch (SQLException e) {
                            System.out.println(e.toString());
                            System.exit(1);
                        }
                        break;
                }
                break;
            case "update":
                if (params.length != 4) {
                    System.out.println("USAGE: App " + command + " subject  fisrtname middlename lastname value");
                    for (String param: params ) {
                        System.out.println(param);
                    }
                    System.exit(1);
                }
                try {
                    _dManager.updateCustomer(subject, params[0], params[1], params[2], params[3]);
                    System.out.println("Successfully updated");
                } catch (SQLException e) {
                    System.out.println(e.toString());
                    System.exit(1);
                } catch (NumberFormatException e) {
                    System.out.println(e.toString() + "\nInvalid customer id.");
                    System.exit(1);
                }
                break;
            case "delete":
                switch (subject) {
                    case "customer":
                        if (params.length != 3) {
                            System.out.println("USAGE: App " + command + " " + subject + " firstname middlename lastname");
                            System.exit(1);
                        }
                        try {
                            _dManager.deleteCustomer(params);
                        } catch (SQLException e) {
                            System.out.println(e.toString());
                            System.exit(1);
                        }
                        break;
                }
                break;
            default:
                    System.out.println("Invalid command: " + command);
        }
    }
}

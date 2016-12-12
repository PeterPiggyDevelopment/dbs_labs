package tk.whitephilosophy.courcework1;

import java.security.InvalidParameterException;
import java.sql.*;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;

public class OracleDatabaseManager implements DatabaseManager {

    //private String connStr = "jdbc:oracle:thin:@localhost:1521:ORBIS";
    private Connection connection;
    public boolean connected;
    private static final String serverName = "localhost";
    private static final String dbms = "oracle";
    private static final String portNumber = "1521";
    private static final String dbsid = "ORBIS";
    private static final String userName = "s192788";
    private static final String password = "pfs295";

    OracleDatabaseManager() throws SQLException {
        connected = false;
        connection = null;
        Properties connectionProps = new Properties();
        connectionProps.put("user", userName);
        connectionProps.put("password", password);

        if (dbms.equals("oracle")) {
            String connectionString =
                    "jdbc:" + dbms + ":thin:@" +
                            serverName +
                            ":" + portNumber + ":" +
                            dbsid;
            System.out.println(connectionString);
            connection = DriverManager.getConnection(
                    connectionString, connectionProps);
        }
        connected = true;
    }

    private void executeQuery(String query, ResultSetFunction rsf) throws SQLException {
        Statement statement = null;
        try {
            statement = connection.createStatement();
            rsf.process(statement.executeQuery(query));
        } catch (SQLException e ) {
            throw new SQLException(e.getMessage());
        } finally {
            if (statement != null) { statement.close(); }
        }
    }

    private void executeQuery(String query) throws SQLException {
        executeQuery(query, (rs) -> {});
    }

    @Override
    public void viewAll(String table) throws SQLException {
        executeQuery("SELECT * FROM ORDERS " +
                "INNER JOIN CUSTOMERS ON ORDERS.CUSTOMER_ID=CUSTOMERS.ID " +
                "INNER JOIN PRODUCTION ON ORDERS.PRODUCT_ID = PRODUCTION.ID " +
                "INNER JOIN PHONES ON PHONES.ID = PRODUCTION.PHONE_ID",
            (rs) -> {
                List<List<String>> rowList = new LinkedList<>();
                while (rs.next()) {
                    List<String> columnList = new LinkedList<>();
                    rowList.add(columnList);
                    for (int column = 1;
                         column <= rs.getMetaData().getColumnCount(); column++) {
                        Object value = rs.getObject(column);
                        if (value != null)
                            columnList.add(value.toString());
                    }
                }
                for (List<String> row: rowList) {
                    for (String value: row) {
                        System.out.print(value + "\t");
                    }
                    System.out.println("");
                }
            });
    }

    @Override
    public void addOrder(String[] params) throws SQLException, InvalidParameterException {
        if (params.length != 6) {
            throw new InvalidParameterException("addOrder params array is too short");
        }
        executeQuery("BEGIN " +
                "CRUD_OPS.ADD_ORDER('" +
                    params[0] + "', '" + params[1] + "', '" +
                    params[2] + "', '" + params[3] + "', '" +
                    params[4] + "', '" + params[5] +
                "'); " +
                "END;");
    }

    @Override
    public void updateCustomer(String field, int id, String value) throws SQLException {
        switch (field) {
            case "firstname":
                executeQuery( "BEGIN " +
                        "CRUD_OPS.UPDATE_CUSTOMER_INFO('" +
                        id + "', '" + value +
                        "', '', '' , '' , ''); " +
                        "END;");
                break;
        }
    }

    @Override
    public void deleteCustomer(String[] field) throws SQLException {
        executeQuery("BEGIN " +
                "CRUD_OPS.DELETE_CUSTOMER('" +
                field[0] + "', '" + field[1] + "', '" +
                field[2] + "'); " +
                "END;");
    }
}

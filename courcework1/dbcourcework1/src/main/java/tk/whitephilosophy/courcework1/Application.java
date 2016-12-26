package tk.whitephilosophy.courcework1;

import java.util.Arrays;
import java.sql.SQLException;

public class Application {

    private static UserRequestHandler requestHandler;
    private static final boolean _withRedis = true;

    static {
        try {
            if (_withRedis) requestHandler = new MainUserRequestHandler(new OracleRedisDatabaseManager());
            else requestHandler = new MainUserRequestHandler(new OracleDatabaseManager());
        } catch (SQLException e) {
            System.out.println(e.toString());
            System.exit(1);
        }
    }

    public static void main(String[] args) {
        if (args.length < 3){
            System.out.println("USAGE: Application command subject params");
            System.exit(1);
        }
        requestHandler.handleUserRequest(args[0], args[1],
            Arrays.copyOfRange(args, 2, args.length));
    }
}

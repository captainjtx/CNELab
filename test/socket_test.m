%Socket test

% message='a=START_SAVE&FILE_PATH=c:\test\traj1\&FILE_NAME=-01900.map';
message='GET TIME\r\n';
%%
output_port=5000;
number_of_retries=50;

import java.net.ServerSocket
import java.io.*

if (nargin < 3)
    number_of_retries = 20; % set to -1 for infinite
end
retry             = 0;

server_socket = ServerSocket(output_port);

server_socket.setSoTimeout(1000000);

% wait for 1 second for client to connect server socket

output_socket = server_socket.accept;

output_stream   = output_socket.getOutputStream;
d_output_stream = DataOutputStream(output_stream);
%%

% output the data over the DataOutputStream
% Convert to stream of bytes

d_output_stream.writeBytes(char(message));
pause(0.5)
d_output_stream.flush;

% clean up
%         server_socket.close;
%         output_socket.close;

message='a=START_SAVE&FILE_PATH=c:\test\traj1\&FILE_NAME=-03600.map';



%%
server_socket.close
output_socket.close
%%

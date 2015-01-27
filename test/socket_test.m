<<<<<<< HEAD
%Socket test

message='a=START_SAVE&FILE_PATH=c:\test\traj1\&FILE_NAME=-01900.map';
=======
%%
message='a=START_SAVE&FILE_PATH=c:\test\traj1\&FILE_NAME=-03700.map';
>>>>>>> 8f5b6e78acfb898784ebad6e72dd8daa4570ef35
output_port=8000;
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

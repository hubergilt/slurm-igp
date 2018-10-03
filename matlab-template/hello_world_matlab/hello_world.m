function out = hello_world(step)
[~, hostname] = system('hostname');
hostname = strtrim(hostname);
fprintf('%s : Hello world with matlab from node %s, rank unknown, run on one processor\n', step, hostname)
end

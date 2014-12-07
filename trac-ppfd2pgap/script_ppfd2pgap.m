% convert PPFD (photosynthetic photon flux density) measurements to gap
% fraction measurement along the transect. 
% Zhan Li, zhanli86@bu.edu
% Created: 2014/09/10
% Last revision: 2014/09/10

clear;
% input file, .trc file of PPFD measurements from the three sensors on TRAC. 
intrcfile = '/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731117.trc';
% input file, a text file of indices of good transects identified by users
% from TRACWin software. 
% File content format:
% one column of indices of good segments
ingoodindfile = '/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731117.ind';
% output file, gap fraction estimate according to Chen & Cihlar 1995, Applied
% Optics
% File content format:
outpgapfile = '/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731117.pgap';

% read all transects and put them in a cell array. 
fid = fopen(intrcfile);
data = textscan(fid, '%s %s %s');
fclose(fid);
nline = length(data{1});
col1 = cell2mat(data{1});
tmpind = find((col1(:, 1)=='9' & col1(:, 2)=='9' & col1(:, 3)=='9' & ...
               col1(:,3)=='9')); 
nseg = length(tmpind);
ppfd = cell(nseg, 1);
startline = tmpind + 1; % the line number where a segment starts
endline = [tmpind(2:end)-1; nline]; % the line number where a segment ends
for n=1:nseg
    tmpcol1 = data{1}(startline(n):endline(n));
    tmpcol2 = data{2}(startline(n):endline(n));
    tmpcol3 = data{3}(startline(n):endline(n));
    ppfd{n} = [str2num(cell2mat(tmpcol1)), str2num(cell2mat(tmpcol2)), ...
               str2num(cell2mat(tmpcol3))];
end

% read the indices of good segments
fid = fopen(ingoodindfile);
ind = textscan(fid, '%d');
fclose(fid);

ind = cell2mat(ind);
goodppfd = ppfd(ind);
% note that every 10 segments is a complete transect. 
ntransect = round(length(ind)/10);
startind = ((1:ntransect)-1)*10+1;
endind = (1:ntransect)*10;
endind(end) = length(ind);
pgap = cell(ntransect, 1);
maxlen = 0;
for n=1:ntransect
    ppfdtr = cell2mat(goodppfd(startind(n):endind(n)));
    pgap{n} = ppfd2pgap(ppfdtr);
    if length(pgap{n})>maxlen
        maxlen = length(pgap{n});
    end
end
% prep to write pgap out to a text file. 
outpgap = nan(maxlen, ntransect);
meanpgap = zeros(ntransect, 1);
for n=1:ntransect
    outpgap(1:length(pgap{n}), n) = pgap{n}(:);
    meanpgap(n) = sum(pgap{n})/length(pgap{n});
end
fid = fopen(outpgapfile, 'w');
fprintf(fid, [repmat('transect_%d,', 1, ntransect-1), 'transect_%d\n'], (1: ...
                                                  ntransect)');
fprintf(fid, [repmat('%.3f,', 1, ntransect-1), '%.3f\n'], meanpgap);
fprintf(fid, [repmat('%d,', 1, ntransect-1), '%d\n'], outpgap');
fclose(fid);

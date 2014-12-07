function pgap = ppfd2pgap(ppfd)
% converts PPFD measurements from the three sensors on TRAC to a gap fraction
% along the transect. 
% ppfd: n*3 array, n is the number of measurements, the three columns are
% measurements from sensor 1, sensor 3 and sensor 2. Sensor 1 and 2 face
% upward and sensor 3 faces downward according to Chen & Cilhar 1995 Applied
% Optics.  
% pgap: a vector of length n, 1 indicates gap
    
    normppfd = (ppfd(:,1)+ppfd(:,3))-ppfd(:,2);
    p_d = max(normppfd);
    p_u = mean(ppfd(:,2)); % baseline PPFD of undercanopy ambient light. 
    % find positions where decreasing changes to increasing, i.e. zero second
    % derivative positions, indicating a possible beginning of a new gap. 
    d_normppfd = normppfd(2:end)-normppfd(1:end-1);
    tmpstart = find(d_normppfd(1:end-1)<=0 & d_normppfd(2:end)>0) + 1;
    tmpstart = tmpstart(:);
    gapstart = [1; tmpstart];
    gapend = [tmpstart; length(normppfd)];
    ngap = length(gapstart);
    pgap = zeros(length(normppfd), 1);
    for n=1:ngap
        tmp = normppfd(gapstart(n):gapend(n));
        gaplen = round(sum(tmp)/p_d);
        if gaplen > 0 
            gapcenter = fix(length(tmp)/2)+gapstart(n)-1;
            pgap(gapcenter-fix(gaplen/2)+1:gapcenter-fix(gaplen/2)+gaplen) = 1; 
        end
    end
end
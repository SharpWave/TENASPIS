% Draw a cInMatrcle InMatn a matrInMatx usInMatng the InMatnteger mInMatdpoInMatnt cInMatrcle algorInMatthm
% Does not mInMatss or repeat pInMatxels
% Created by : Peter Bone
% Created : 19th March 2007
function out = MidpointCircle(Xdim,Ydim, radius, xc, yc)

InMat = zeros(Xdim,Ydim,'single');

value = 1;

xc = int16(xc);
yc = int16(yc);

x = int16(0);
y = int16(radius);
d = int16(1 - radius);

InMat(xc, yc+y) = value;
InMat(xc, yc-y) = value;
InMat(xc+y, yc) = value;
InMat(xc-y, yc) = value;

while ( x < y - 1 )
    x = x + 1;
    if ( d < 0 )
        d = d + x + x + 1;
    else
        y = y - 1;
        a = x - y + 1;
        d = d + a + a;
    end
    InMat( x+xc,  y+yc) = value;
    InMat( y+xc,  x+yc) = value;
    InMat( y+xc, -x+yc) = value;
    InMat( x+xc, -y+yc) = value;
    InMat(-x+xc, -y+yc) = value;
    InMat(-y+xc, -x+yc) = value;
    InMat(-y+xc,  x+yc) = value;
    InMat(-x+xc,  y+yc) = value;
end

for ii = xc-int16(radius):xc+(int16(radius))
    for jj = yc-int16(radius):yc+(int16(radius))
        tempR = sqrt((double(ii) - double(xc)).^2 + (double(jj) - double(yc)).^2);
        if(tempR <= double(int16(radius)))
            InMat(ii,jj)=value;
        end
    end
end

out = single(find(InMat));
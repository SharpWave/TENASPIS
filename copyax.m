% copyax(Action, [hTo], [hFrom],Printget)
% this function will save your eyesight!
% it alows you to zoom/copy the subplots of multisubplot figures
% with ease with just one mouse click
% Action:
% to start the mode : copyax('on')
% after that the current 
% to stop :                 copyax('off')
% hTo  - handle of the figure where to copy (if absent or empty - default: new Figure)
% hFrom - handle of the figure to act on (if absent or empty - default - current figure)
% it acts currently only on the click withing hFrom figure
% now the clicks:
% left click: zoom the subplot you clicked on to the figure size
% left click again: zoom it back . other axes will be invisible
% right click: copy subplot clocked on to another figure (hTo)
% this figure will be always used for copy if you right click again
% double right click: copy, but to a new (not hTo) figure
% middle click: (notimplemented yet)
% but when finished, will add clicked axes to the existing in
% hTo and rearrange them at your wish.
% Cool, ah? 
% say thanks to
% Matlab6 functionality 
% 

function copyax(varargin)
defFrom = gcf;
AllFigs = get(0,'Children');
defTo = max(AllFigs)+1;
defPos = [   0.130    0.110    0.775    0.815];
[Action, hTo, hFrom,IfPrint] = DefaultArgs(varargin, {'copy', defTo,defFrom,[]});
global gcopyax
switch Action
case    'on'
    gcopyax.hTo = hTo;
    gcopyax.hFrom = hFrom;
    gcopyax.IfPrint = IfPrint;
    gcopyax.zoom =1;   
    set(hFrom, 'WindowButtonDownFcn', 'copyax');
    set(hFrom,'DeleteFcn','clear(''gcopyax'',''global'')');
    
%    set(hFrom,'Pointer','circle');
    set(hFrom,'Pointer','arrow');
    set(hFrom,'Name',' copyax in action');
    ForAllSubplots('axis off');
    
case    'off'
    set(gcopyax.hFrom, 'ButtonDownFcn', []);
    set(hFrom,'Pointer','arrow');
    set(hFrom,'Name','');
    clear global gcopyax;
    
case    'copy'
    %    fprintf('Works\n');
    
    hAxes = get(hFrom, 'CurrentAxes');
    allAxes = get(hFrom, 'Children');
    if isempty(get(hFrom, 'WindowButtonDownFcn'))
        % just normal call, not using mouse (callback was not set on)
        figure(hTo);
        copyobj(hAxes, hTo);   
    else
        % analyze mouse clicks
        whatbutton = get(gcf,'SelectionType');
        switch whatbutton
            case 'alt'      % right click

                % zoom in/out current axes
                curPos = get(hAxes,'Position');
                otherAxes = setdiff(allAxes, hAxes);
                newAxes = [hAxes; otherAxes];
                set(hFrom, 'Children', newAxes);

                if gcopyax.zoom & sum(defPos ==curPos)<4
                    % zoom out
                    gcopyax.oldPos = curPos;
                    set(otherAxes,'Visible','off');
                    set(hAxes, 'Position', defPos);
                    %                set(hAxes, 'Layer', 'top');
                    gcopyax.zoom=0;
                else
                    %zoom in
                    set(hAxes, 'Position', gcopyax.oldPos);
                    %set(otherAxes,'Visible','on');
                    %ForAllSubplots('axis off');
                    %               set(hAxes, 'Layer', 'bottom');
                    gcopyax.zoom=1;
                end

            case 'normal' % left click
                %copy into the default figure (fixed from initialization)
                figure(gcopyax.hTo);
                clf
                copyobj(hAxes, gcopyax.hTo);
                %find(allAxes,hAxes)
                %set(gcopyax.hTo,'Name',num2str(find(allAxes,hAxes)));
                set(gca, 'Position', defPos);
                set(gca, 'Visible','on');
                figure(gcopyax.hTo);
                set(gca,'XTickMode','auto');grid on
                if ~isempty(gcopyax.IfPrint)
                  %  keyboard
                    prteps(gcopyax.IfPrint,gcopyax.hTo);
                end
            case  'extend'  % middle click
                % add to the defalt  figure (arrange the sublots that are there)
                fprintf('this feature is not implemented yet : after SFN! \n');
                %                  figure(gcopyax.hTo);
                %                 existingAxes = get(gcopyax.hTo, 'Children');
                %                    copyobj(hAxes,gcopyax.hTo);
                %                  jointAxes = [existingAxes; hAxes];
                %                  copyobj(jointAxes, gcopyax.hTo);

            case 'open'     %double click
                %copy in the new figure
                figure(hTo);
                clf
                copyobj(hAxes, hTo);
                set(gca, 'Position', defPos);
        end
    end
end




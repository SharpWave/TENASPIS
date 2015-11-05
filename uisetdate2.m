function outdate = uisetdate2(varargin)
%UISETDATE2 Interactive date selection. This function is based on MATLAB's
%built in 'calendar' function.
%
%   SYNTAX:
%   outdate = uisetdate2 : Opens an interactive date selection GUI. This
%   function suspends execution until date selection is complete or
%   cancelled. Returns a 1-by-3 partial date vector 'outdate' containing
%   the selected year, month, and day as its respective elements.
%
%   outdate = uisetdate2(<Property>, <Value>, ...): Allows the user to
%   specify property/value pairs
%
%   PROPERTY/VALUE PAIRS
%   'MIN_YEAR', <1>: The minimum selectable year is specified. It should
%   not be less than 1.
%
%   'MAX_YEAR', <9999>: The maximum selectable year is specified. It should
%   not be greater than 9999, and should always be greater than or equal to
%   MIN_YEAR.
%
%   'StartingDate', <[]>: The starting date can be specified as a
%   date vector (or a partial date vector of three elements containing
%   year, month, and day). This date will be set when the interface is
%   launched. If the year corresponding to this StartingDate is outside the
%   range [MIN_YEAR, MAX_YEAR] then the year field of the date
%   vector is limited to MIN_YEAR or MAX_YEAR, as the case may be. It is
%   also possible to specify N date vectors to be selected as an N-by-3
%   (partial date vector) or N-by-6 (full date vector) matrix.
%
%   'MULTI_SELECT', <false>: If set to true, the user can select multiple
%   dates interactively. The return value is then an N-by-3 matrix of
%   partial date vectors where N is the number of dates selected.
%
%   See also: calendar, datevec, datenum, datestr
%
%   Copyright (C) 2011 Sundeep Tuteja
%   All Rights Reserved

%Setting some persistent variables
persistent FIGURE_HANDLE;
persistent HANDLES;
persistent MIN_YEAR; %#ok<USENS>
persistent MAX_YEAR; %#ok<USENS>
persistent SELECTED_DATES;
persistent MULTI_SELECT; %#ok<USENS>

%Default action: init
pairs = {'action', 'init'};
parseargs(varargin, pairs);

%The following colors can be changed according to one's preference. These
%can also be normalized RGB triplets.
btnRCColor = 'yellow';
selected_btnRCColor = 'red';
btnOKColor = 'green';
btnCancelColor = 'green';
btnTodayColor = 'green';
btnClearColor = 'green';
btnPreviousYearColor = 'yellow';
btnPreviousMonthColor = 'yellow';
popupMonthColor = 'white';
popupYearColor = 'white';
btnNextMonthColor = 'yellow';
btnNextYearColor = 'yellow';
btnDayColor = 'green';

switch action
    
    %% CASE init
    case 'init'
        %Initialization code
        pairs = {'StartingDate', [], ...
            'MIN_YEAR', 1, ...
            'MAX_YEAR', 9999, ...
            'MULTI_SELECT', false};
        parseargs(varargin, pairs);
        
        Units = 'pixels';
        
        if ~isempty(StartingDate) %#ok<NODEF>
            %Conditioning StartingDate as necessary
            StartingDate(StartingDate(:, 1) < MIN_YEAR, 1) = MIN_YEAR;
            StartingDate(StartingDate(:, 1) > MAX_YEAR, 1) = MAX_YEAR;
            YearList = StartingDate(:, 1);
            MonthList = StartingDate(:, 2);
            DayList = StartingDate(:, 3);
            maxdaylist = arrayfun(@getmaxdays, YearList, MonthList);
            StartingDate(DayList > maxdaylist, 3) = maxdaylist(DayList > maxdaylist);
            
            %Initializing persistent variable SELECTED_DATES
            SELECTED_DATES = StartingDate(:, 1:3);
            for ctr = size(SELECTED_DATES, 1):-1:2
                if ismember(SELECTED_DATES(ctr, :), SELECTED_DATES(1:ctr-1, :), 'rows')
                    SELECTED_DATES(ctr, :) = [];
                end
            end
            
            StartingDate = datenum(StartingDate(end, :));
        else
            SELECTED_DATES = zeros(0, 3);
            StartingDate = now;
        end
        
        %Creating complete list of months, years, and days of the week
        MonthList = arrayfun(@(x) datestr(datenum(num2str(x), 'mm'), 'mmmm'), ...
            (1:12).', ...
            'UniformOutput', false);
        YearList = strtrim(cellstr(num2str((MIN_YEAR:MAX_YEAR).')));
        CurrentDateVec = datevec(now);
        thisMonthCalendar = calendar;
        thisMonthSundays = thisMonthCalendar(:, 1);
        thisMonthSundays(thisMonthSundays == 0) = [];
        FirstSunday = thisMonthSundays(1);
        DayList = arrayfun(@(X) datestr(datenum([CurrentDateVec(1:2) X]), 'dddd'), ...
            (FirstSunday:FirstSunday+6).', ...
            'UniformOutput', false);
        DayList_abbr = arrayfun(@(X) datestr(datenum([CurrentDateVec(1:2) X]), 'ddd'), ...
            (FirstSunday:FirstSunday+6).', ...
            'UniformOutput', false);
        
        %Positions
        pairs = {['figure_' mfilename '_position'],                               [524  234  287  336], ...
            'btnClear_position',                               [217   -1   72   31], ...
            'btnToday_position',                               [148   -1   70   31], ...
            'btnCancel_position',                                   [68  -1  81  31], ...
            'btnOK_position',                                    [0  -1  69  31], ...
            'btnR6C7_position', [246.8599      28.99933      42.14782      42.00088], ...
            'btnR6C6_position', [205.7159      28.99933      42.14782      42.00088], ...
            'btnR6C5_position', [164.572      28.99933      42.14782      42.00088], ...
            'btnR6C4_position', [123.428      28.99933      42.14782      42.00088], ...
            'btnR6C3_position',   [82.2841      28.9993      42.1478      42.0009], ...
            'btnR6C2_position',   [41.1401      28.9993      42.1478      42.0009], ...
            'btnR6C1_position', [-0.0035168      28.9993      42.1478      42.0009], ...
            'btnR5C7_position', [246.8599      70.00085      42.14782      42.00088], ...
            'btnR5C6_position', [205.7159      70.00085      42.14782      42.00088], ...
            'btnR5C5_position', [164.572      70.00085      42.14782      42.00088], ...
            'btnR5C4_position', [123.428      70.00085      42.14782      42.00088], ...
            'btnR5C3_position',   [82.2841      70.0008      42.1478      42.0009], ...
            'btnR5C2_position',   [41.1401      70.0008      42.1478      42.0009], ...
            'btnR5C1_position', [-0.0035168      70.0008      42.1478      42.0009], ...
            'btnR4C7_position', [246.8599      110.9989      42.14782      42.00088], ...
            'btnR4C6_position', [205.7159      110.9989      42.14782      42.00088], ...
            'btnR4C5_position', [164.572      110.9989      42.14782      42.00088], ...
            'btnR4C4_position', [123.428      110.9989      42.14782      42.00088], ...
            'btnR4C3_position', [82.28406      110.9989      42.14782      42.00088], ...
            'btnR4C2_position', [41.1401      110.9989      42.14782      42.00088], ...
            'btnR4C1_position', [-0.0035168      110.9989      42.14782      42.00088], ...
            'btnR3C7_position', [246.8599      152.0004      42.14782      42.00088], ...
            'btnR3C6_position', [205.7159      152.0004      42.14782      42.00088], ...
            'btnR3C5_position', [164.572      152.0004      42.14782      42.00088], ...
            'btnR3C4_position', [123.428      152.0004      42.14782      42.00088], ...
            'btnR3C3_position', [82.28406      152.0004      42.14782      42.00088], ...
            'btnR3C2_position', [41.1401      152.0004      42.14782      42.00088], ...
            'btnR3C1_position', [-0.0035168      152.0004      42.14782      42.00088], ...
            'btnR2C7_position', [246.8599      192.9985      42.14782      42.00088], ...
            'btnR2C6_position', [205.7159      192.9985      42.14782      42.00088], ...
            'btnR2C5_position', [164.572      192.9985      42.14782      42.00088], ...
            'btnR2C4_position', [123.428      192.9985      42.14782      42.00088], ...
            'btnR2C3_position', [82.28406      192.9985      42.14782      42.00088], ...
            'btnR2C2_position', [41.1401      192.9985      42.14782      42.00088], ...
            'btnR2C1_position', [-0.0035168      192.9985      42.14782      42.00088], ...
            'btnR1C7_position', [246.8599           234      42.14782      42.00088], ...
            'btnR1C6_position', [205.7159           234      42.14782      42.00088], ...
            'btnR1C5_position', [164.572           234      42.14782      42.00088], ...
            'btnR1C4_position', [123.428           234      42.14782      42.00088], ...
            'btnR1C3_position', [82.28406           234      42.14782      42.00088], ...
            'btnR1C2_position', [41.1401           234      42.14782      42.00088], ...
            'btnR1C1_position', [-0.0035168           234      42.14782      42.00088], ...
            'btnSaturday_position', [246.8599      275.0015      42.14782      42.00088], ...
            'btnFriday_position', [205.7159      275.0015      42.14782      42.00088], ...
            'btnThursday_position', [164.572      275.0015      42.14782      42.00088], ...
            'btnWednesday_position', [123.428      275.0015      42.14782      42.00088], ...
            'btnTuesday_position', [82.28406      275.0015      42.14782      42.00088], ...
            'btnMonday_position', [41.1401      275.0015      42.14782      42.00088], ...
            'btnSunday_position', [-0.0035168      275.0015      42.14782      42.00088], ...
            'btnNextYear_position', [259.9044      315.9996       29.1005      22.00015], ...
            'btnNextMonth_position', [231.8077      315.9996       29.1005      22.00015], ...
            'popupYear_position', [164.572      315.0002      69.24346      22.99985], ...
            'popupMonth_position', [56.19228      315.0002      109.3836      22.99985], ...
            'btnPreviousMonth_position', [28.09478      315.9996       29.1005      22.00015], ...
            'btnPreviousYear_position', [-0.0035168      315.9996       29.1005      22.00015]};
        parseargs(pairs);
        
        %Centering figure window
        screensize = get(0, 'ScreenSize');
        figurepos = eval(['figure_' mfilename '_position']);
        xpos = 0.5*(screensize(3) - figurepos(3)); %#ok<NASGU>
        ypos = 0.5*(screensize(4) - figurepos(4)); %#ok<NASGU>
        eval(['figure_' mfilename '_position([1 2]) = [xpos ypos];']);
        
        FIGURE_HANDLE = figure('MenuBar', 'none', ...
            'Units', Units, ...
            'WindowStyle', 'normal', ...
            'Resize', 'off', ...
            'Name', mfilename, ...
            'CloseRequestFcn', [mfilename '(''action'', ''btnCancelCallback'');'], ...
            'Position', eval(['figure_' mfilename '_position']));
        
        BooleanStr = {'off', 'on'};
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnPreviousYear', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnPreviousYearColor, ...
            'FontSize', 13, ...
            'String', '<<', ...
            'Enable', BooleanStr{double(prevyearexists(StartingDate, MIN_YEAR))+1}, ...
            'TooltipString', 'Previous Year', ...
            'Position', btnPreviousYear_position, ...
            'Callback', [mfilename '(''action'', ''btnPreviousYearCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnPreviousMonth', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnPreviousMonthColor, ...
            'FontSize', 13, ...
            'String', '<', ...
            'Enable', BooleanStr{double(prevmonthexists(StartingDate, MIN_YEAR))+1}, ...
            'TooltipString', 'Previous Month', ...
            'Position', btnPreviousMonth_position, ...
            'Callback', [mfilename '(''action'', ''btnPreviousMonthCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'popupMonth', ...
            'Style', 'popup', ...
            'BackgroundColor', popupMonthColor, ...
            'String', MonthList, ...
            'TooltipString', 'Month', ...
            'Position', popupMonth_position, ...
            'Value', str2double(datestr(StartingDate, 'mm')), ...
            'Callback', [mfilename '(''action'', ''popupMonthCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'popupYear', ...
            'Style', 'popup', ...
            'BackgroundColor', popupYearColor, ...
            'String', YearList, ...
            'TooltipString', 'Year', ...
            'Position', popupYear_position, ...
            'Value', find(strcmp(datestr(StartingDate, 'yyyy'), YearList), 1), ...
            'Callback', [mfilename '(''action'', ''popupYearCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnNextMonth', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnNextMonthColor, ...
            'FontSize', 13, ...
            'String', '>', ...
            'Enable', BooleanStr{double(nextmonthexists(StartingDate, MAX_YEAR))+1}, ...
            'TooltipString', 'Next Month', ...
            'Position', btnNextMonth_position, ...
            'Callback', [mfilename '(''action'', ''btnNextMonthCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnNextYear', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnNextYearColor, ...
            'FontSize', 13, ...
            'String', '>>', ...
            'Enable', BooleanStr{double(nextyearexists(StartingDate, MAX_YEAR))+1}, ...
            'TooltipString', 'Next Year', ...
            'Position', btnNextYear_position, ...
            'Callback', [mfilename '(''action'', ''btnNextYearCallback'');']);
        
        BooleanStr = {'inactive', 'on'};
        for dayctr = 1:7
            uicontrol('Parent', FIGURE_HANDLE, ...
                'Units', Units, ...
                'Tag', ['btn' DayList{dayctr}], ...
                'Style', 'pushbutton', ...
                'BackgroundColor', btnDayColor, ...
                'FontSize', 10, ...
                'String', upper(DayList_abbr{dayctr}), ...
                'TooltipString', DayList{dayctr}, ...
                'Position', eval(['btn' DayList{dayctr} '_position']), ...
                'Enable', BooleanStr{double(MULTI_SELECT)+1}, ...
                'Callback', [mfilename '(''action'', ''btnDayCallback'', ''Day'', ' num2str(dayctr) ');']);
        end
        
        calendar_matrix = calendar(StartingDate);
        for rowctr = 1:size(calendar_matrix, 1)
            for colctr = 1:size(calendar_matrix, 2)
                thistag = ['btnR' num2str(rowctr) 'C' num2str(colctr)];
                
                uicontrol('Parent', FIGURE_HANDLE, ...
                    'Units', Units, ...
                    'Tag', thistag, ...
                    'Style', 'pushbutton', ...
                    'BackgroundColor', btnRCColor, ...
                    'FontSize', 10, ...
                    'String', '', ...
                    'TooltipString', '', ...
                    'Position', eval([thistag '_position']), ...
                    'Callback', [mfilename '(''action'', ''btnRCCallback'', ''Row'', ' num2str(rowctr) ', ''Column'', ' num2str(colctr) ');']);
            end
        end
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnOK', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnOKColor, ...
            'FontSize', 13, ...
            'String', 'OK', ...
            'TooltipString', 'OK', ...
            'Position', btnOK_position, ...
            'Callback', [mfilename '(''action'', ''btnOKCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnCancel', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnCancelColor, ...
            'FontSize', 13, ...
            'String', 'CANCEL', ...
            'TooltipString', 'Cancel', ...
            'Position', btnCancel_position, ...
            'Callback', [mfilename '(''action'', ''btnCancelCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnToday', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnTodayColor, ...
            'FontSize', 13, ...
            'String', 'TODAY', ...
            'TooltipString', 'Select today''s date', ...
            'Position', btnToday_position, ...
            'Callback', [mfilename '(''action'', ''btnTodayCallback'');']);
        
        uicontrol('Parent', FIGURE_HANDLE, ...
            'Units', Units, ...
            'Tag', 'btnToday', ...
            'Style', 'pushbutton', ...
            'BackgroundColor', btnClearColor, ...
            'FontSize', 13, ...
            'String', 'CLEAR', ...
            'TooltipString', 'Clear your selection(s)', ...
            'Position', btnClear_position, ...
            'Callback', [mfilename '(''action'', ''btnClearCallback'');']);
        
        HANDLES = guihandles(FIGURE_HANDLE);
        
        feval(mfilename, 'action', 'refresh_calendar');
        uiwait(FIGURE_HANDLE);
        outdate = SELECTED_DATES;
        feval(mfilename, 'action', 'close');
        
        %% CASE btnPreviousYearCallback
    case 'btnPreviousYearCallback'
        YearValue = get(HANDLES.popupYear, 'Value');
        set(HANDLES.popupYear, 'Value', YearValue-1);
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnPreviousMonthCallback
    case 'btnPreviousMonthCallback'
        YearValue = get(HANDLES.popupYear, 'Value');
        MonthValue = get(HANDLES.popupMonth, 'Value');
        newMonthValue = MonthValue - 1;
        if newMonthValue == 0
            newMonthValue = 12;
            newYearValue = YearValue - 1;
        else
            newYearValue = YearValue;
        end
        set(HANDLES.popupMonth, 'Value', newMonthValue);
        set(HANDLES.popupYear, 'Value', newYearValue);
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE refresh_calendar
    case 'refresh_calendar'
        BackgroundColor = {btnRCColor, selected_btnRCColor};
        
        MonthList = get(HANDLES.popupMonth, 'String');
        YearList = get(HANDLES.popupYear, 'String');
        thisMonth = str2double(datestr(datenum(MonthList{get(HANDLES.popupMonth, 'Value')}, 'mmmm'), 'mm'));
        thisYear = str2double(YearList{get(HANDLES.popupYear, 'Value')});
        calendar_matrix = calendar(thisYear, thisMonth);
        
        if ~isempty(SELECTED_DATES)
            last_selected_date = SELECTED_DATES(end, :);
            thisDay = last_selected_date(3);
        else
            thisDay = 1;
        end
        
        BooleanStr = {'off', 'on'};
        thisDateNum = datenum([thisYear thisMonth thisDay]);
        set(HANDLES.btnPreviousYear, 'Enable', BooleanStr{double(prevyearexists(thisDateNum, MIN_YEAR))+1});
        set(HANDLES.btnPreviousMonth, 'Enable', BooleanStr{double(prevmonthexists(thisDateNum, MIN_YEAR))+1});
        set(HANDLES.btnNextMonth, 'Enable', BooleanStr{double(nextmonthexists(thisDateNum, MAX_YEAR))+1});
        set(HANDLES.btnNextYear, 'Enable', BooleanStr{double(nextyearexists(thisDateNum, MAX_YEAR))+1});
        
        calendar_matrix_prev = calendar(thisDateNum-thisDay);
        if all(calendar_matrix_prev(end, :) == 0)
            calendar_matrix_prev(end, :) = [];
        end
        calendar_matrix_next = calendar(thisDateNum+getmaxdays(thisYear, thisMonth)-thisDay+1);
        
        rowctr_next = 1;
        for rowctr = 1:size(calendar_matrix, 1)
            for colctr = 1:size(calendar_matrix, 2)
                thistag = ['btnR' num2str(rowctr) 'C' num2str(colctr)];
                ShouldEnable = BooleanStr{double(calendar_matrix(rowctr, colctr) ~= 0) + 1};
                
                %If this date is in the list of selected dates, set the
                %background color appropriately
                thisDate = calendar_matrix(rowctr, colctr);
                if ismember([thisYear thisMonth thisDate], SELECTED_DATES, 'rows')
                    thisBackgroundColor = BackgroundColor{2};
                else
                    thisBackgroundColor = BackgroundColor{1};
                end
                
                todayDateVec = datevec(now);
                if isequal(todayDateVec(1, 1:3), [thisYear thisMonth thisDate])
                    FontWeight = 'bold';
                else
                    FontWeight = 'normal';
                end
                
                %Modify calendar_matrix to include dates from the previous
                %month and the following month
                if calendar_matrix(rowctr, colctr) == 0
                    if rowctr == 1
                        calendar_matrix(rowctr, colctr) = calendar_matrix_prev(end, colctr);
                    else
                        calendar_matrix(rowctr, colctr) = calendar_matrix_next(rowctr_next, colctr);
                        if colctr == size(calendar_matrix, 2)
                            rowctr_next = rowctr_next + 1;
                        end
                    end
                end
                
                set(HANDLES.(thistag), 'String', num2str(calendar_matrix(rowctr, colctr)), ...
                    'TooltipString', datestr(datenum([thisYear thisMonth thisDate]), 'DDDD, dd mmmm, yyyy'), ...
                    'Enable', ShouldEnable, ...
                    'BackgroundColor', thisBackgroundColor, ...
                    'FontWeight', FontWeight);
            end
        end
        
        %% CASE popupMonthCallback
    case 'popupMonthCallback'
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE popupYearCallback
    case 'popupYearCallback'
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnNextMonthCallback
    case 'btnNextMonthCallback'
        YearValue = get(HANDLES.popupYear, 'Value');
        MonthValue = get(HANDLES.popupMonth, 'Value');
        newMonthValue = MonthValue + 1;
        if newMonthValue == 13
            newMonthValue = 1;
            newYearValue = YearValue + 1;
        else
            newYearValue = YearValue;
        end
        set(HANDLES.popupMonth, 'Value', newMonthValue);
        set(HANDLES.popupYear, 'Value', newYearValue);
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnNextYearCallback
    case 'btnNextYearCallback'
        YearValue = get(HANDLES.popupYear, 'Value');
        set(HANDLES.popupYear, 'Value', YearValue+1);
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnDayCallback
    case 'btnDayCallback'
        if ~MULTI_SELECT
            return;
        end
        
        pairs = {'Day', []};
        parseargs(varargin, pairs);
        
        MonthList = get(HANDLES.popupMonth, 'String');
        YearList = get(HANDLES.popupYear, 'String');
        thisMonth = str2double(datestr(datenum(MonthList{get(HANDLES.popupMonth, 'Value')}, 'mmmm'), 'mm'));
        thisYear = str2double(YearList{get(HANDLES.popupYear, 'Value')});
        calendar_matrix = calendar(thisYear, thisMonth);
        theseDates = calendar_matrix(:, Day);
        theseDates(theseDates == 0) = [];
        
        added_dates = [repmat(thisYear, length(theseDates), 1) repmat(thisMonth, length(theseDates), 1) theseDates];
        [is_already_selected, loc] = ismember(added_dates, SELECTED_DATES, 'rows');
        SELECTED_DATES(loc(loc >= 1), :) = [];
        if ~all(is_already_selected)
            SELECTED_DATES = [SELECTED_DATES; added_dates];
        end
        
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnRCCallback
    case 'btnRCCallback'
        pairs = {'Row', [], ...
            'Column', []};
        parseargs(varargin, pairs);
        
        %Get the clicked date
        MonthList = get(HANDLES.popupMonth, 'String');
        YearList = get(HANDLES.popupYear, 'String');
        thisMonth = str2double(datestr(datenum(MonthList{get(HANDLES.popupMonth, 'Value')}, 'mmmm'), 'mm'));
        thisYear = str2double(YearList{get(HANDLES.popupYear, 'Value')});
        calendar_matrix = calendar(thisYear, thisMonth);
        thisDay = calendar_matrix(Row, Column);
        
        [is_already_selected, loc] = ismember([thisYear thisMonth thisDay], SELECTED_DATES, 'rows');
        if is_already_selected
            SELECTED_DATES(loc, :) = [];
        else
            if MULTI_SELECT
                SELECTED_DATES = [SELECTED_DATES; [thisYear thisMonth thisDay]];
            else
                SELECTED_DATES = [thisYear thisMonth thisDay];
            end
        end
        
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnOKCallback
    case 'btnOKCallback'
        if isempty(SELECTED_DATES)
            errordlg('No date(s) have been selected.');
            return;
        end
        uiresume(FIGURE_HANDLE);
        
        %% CASE btnCancelCallback
    case 'btnCancelCallback'
        SELECTED_DATES = zeros(0, 3);
        uiresume(FIGURE_HANDLE);
        
        %% CASE btnTodayCallback
    case 'btnTodayCallback'
        thisYear = str2double(datestr(now, 'yyyy'));
        
        if thisYear < MIN_YEAR || thisYear > MAX_YEAR
            return;
        end
        
        thisMonth = str2double(datestr(now, 'mm'));
        thisDay = str2double(datestr(now, 'dd'));
        
        [is_already_selected, loc] = ismember([thisYear thisMonth thisDay], SELECTED_DATES, 'rows');
        if is_already_selected
            SELECTED_DATES(loc, :) = [];
        end
        if MULTI_SELECT
            SELECTED_DATES = [SELECTED_DATES; [thisYear thisMonth thisDay]];
        else
            SELECTED_DATES = [thisYear thisMonth thisDay];
        end
        
        MonthList = get(HANDLES.popupMonth, 'String');
        YearList = get(HANDLES.popupYear, 'String');
        thisMonth = datestr(now, 'mmmm');
        thisYear = num2str(thisYear);
        
        set(HANDLES.popupMonth, 'Value', find(strcmp(thisMonth, MonthList), 1));
        set(HANDLES.popupYear, 'Value', find(strcmp(thisYear, YearList), 1));
        
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE btnClearCallback
    case 'btnClearCallback'
        SELECTED_DATES = zeros(0, 3);
        feval(mfilename, 'action', 'refresh_calendar');
        
        %% CASE close
    case 'close'
        delete(FIGURE_HANDLE);
        clear(mfilename);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% HELPER FUNCTIONS

function out = prevyearexists(dateval, MIN_YEAR)

thisyear = str2double(datestr(dateval, 'yyyy'));
out = (thisyear >= MIN_YEAR+1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = prevmonthexists(dateval, MIN_YEAR)

thisyear = str2double(datestr(dateval, 'yyyy'));
thismonth = str2double(datestr(dateval, 'mm'));

out = (thismonth >=2 && thismonth <= 12) || (thismonth == 1 && thisyear >= MIN_YEAR+1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = nextyearexists(dateval, MAX_YEAR)

thisyear = str2double(datestr(dateval, 'yyyy'));
out = (thisyear <= MAX_YEAR-1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = nextmonthexists(dateval, MAX_YEAR)

thisyear = str2double(datestr(dateval, 'yyyy'));
thismonth = str2double(datestr(dateval, 'mm'));
out = (thismonth >= 1 && thismonth <= 11) || (thismonth == 12 && thisyear <= MAX_YEAR-1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = getmaxdays(yearval, monthval)

febdays = [28 29];
maxdays = [9 30;
    4 30;
    6 30;
    11 30;
    2 febdays(double(isleapyear(yearval))+1);
    1 31;
    3 31;
    5 31;
    7 31;
    8 31;
    10 31;
    12 31];
out = maxdays(maxdays(:, 1)==monthval, 2);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = isleapyear(varargin)

if nargin == 0
    yearval = str2double(datestr(now, 'yyyy'));
elseif nargin == 1
    yearval = varargin{1};
end

if mod(yearval, 400) == 0
    out = true;
elseif mod(yearval, 100) == 0
    out = false;
elseif mod(yearval, 4) == 0
    out = true;
else
    out = false;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = parseargs(varargin_pairs, pairs)
%PARSEARGS Simplified argument parsing
%   PARSEARGS(ARGLIST): ARGLIST is a cell array having the format
%   <VarName>, <VarValue>, <VarName>, <VarValue>, ... Each variable name is
%   instantiated in the calling function's workspace, with the corresponding
%   value. <VarVal> can be anything.
%
%   PARSEARGS(ARGLIST, DEFAULT_PAIRS): If DEFAULT_PAIRS is specified, the
%   values instantiated will be the ones specified in DEFAULT_PAIRS if the
%   corresponding values have not been specified in ARGLIST (i.e. ARGLIST
%   contains override values). DEFAULT_PAIRS has the same format as
%   ARGLIST.
%
%   e.g.
%   pairs = {'variable1', 10, ...
%            'variable2', 20, ...
%            'variable3', 30};
%   arglist = {'variable2', 'pqr'};
%   parseargs(arglist, pairs);
%
%   This will result in the variables 'variable1' (value 10), 'variable2'
%   (value 'pqr'), and 'variable3' (value 30) being instantiated in the
%   current workspace.

if nargin == 1
    pairs = varargin_pairs;
end

pairs = [columnvec(pairs(1:2:end)) columnvec(pairs(2:2:end))];

is_reserved_list = cellfun(@iskeyword, pairs(:, 1));
if any(is_reserved_list)
    error([mfilename ':parseargs:ReservedWord'], ['''' pairs{find(is_reserved_list, 1), 1} ''' is a reserved word.']);
end

varargin_pairs = [columnvec(varargin_pairs(1:2:end)) columnvec(varargin_pairs(2:2:end))];
[override_indices, loc] = ismember(pairs(:, 1), varargin_pairs(:, 1));
pairs(override_indices, 2) = varargin_pairs(loc(loc ~= 0), 2);

for ctr = 1:size(pairs, 1)
    assignin('caller', pairs{ctr, 1}, pairs{ctr, 2});
end

varargout{1} = rowvec(columnvec(pairs.'));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function matrix = columnvec(matrix)

matrix = matrix(:);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function matrix = rowvec(matrix)

matrix = (matrix(:)).';

end
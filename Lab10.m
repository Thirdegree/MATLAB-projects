function [] = Lab10()
    
    left = NXTMotor('C');
    right = NXTMotor('B');
    pivotMotor = NXTMotor('A');
    both = NXTMotor('BC');
    
    
    ultra = SENSOR_1;
    
    OpenUltrasonic(ultra);

    nintyDegree = 200;

    
    function [] = forward()
        both.Power = -100;
        both.SendToNXT();
    end
    
    function [] = pivot(a)
        switch a
            case 'right'
                right.TachoLimit = nintyDegree;
                left.TachoLimit = nintyDegree;
                forwardRight();
                forwardLeft();
                right.WaitFor();
                left.WaitFor();
                stop();
                right.TachoLimit = 0;
                left.TachoLimit = 0;
            case 'left'
                right.TachoLimit = nintyDegree;
                left.TachoLimit = nintyDegree;
                reverseRight();
                reverseLeft();
                right.WaitFor();
                left.WaitFor();
                stop();
                right.TachoLimit = 0;
                left.TachoLimit = 0;
        end
    end
        
    function [] = forwardRight()
        right.Power = 100;
        right.SendToNXT();
    end
    
    function [] = forwardLeft()
        left.Power = -100;
        left.SendToNXT();
    end
    
    function [] = reverseRight()
        right.Power = -100;
        right.SendToNXT();
    end
    
    function [] = reverseLeft()
        left.Power = 100;
        left.SendToNXT();
    end
    
    
    function [] = stop()
        both.Power = 0;
        both.SendToNXT();
    end


        
    function [y] = checkFront()
        if GetUltrasonic(ultra)<40
            y = true;
        else
            y=false;
        end
    end
    
    function [y] = checkLeft()
        pivotMotor.Power = 100;
        pivotMotor.TachoLimit = 90;
        pivotMotor.SendToNXT();
        pivotMotor.WaitFor();
        if GetUltrasonic(ultra)<40
            y = true;
        else
            y=false;
        end
        pivotMotor.Power = -100;
        
        pivotMotor.SendToNXT();
        pivotMotor.WaitFor();
        pivotMotor.TachoLimit = 0;
    end
    
    function [y] = checkRight()
        pivotMotor.Power = -100;
        pivotMotor.TachoLimit = 90;
        pivotMotor.SendToNXT();
        pivotMotor.WaitFor();
        if GetUltrasonic(ultra)<40
            y = true;
        else
            y=false;
        end
        pivotMotor.Power = 100;
        pivotMotor.SendToNXT();
        pivotMotor.WaitFor();
        pivotMotor.TachoLimit = 0;
    end
    
    function [y] = checkBehind()
        pivotMotor.Power = 100;
        pivotMotor.TachoLimit = 180;
        pivotMotor.SendToNXT();
        pivotMotor.WaitFor();
        if GetUltrasonic(ultra)<40
            y = true;
        else
            y=false;
        end
        pivotMotor.Power = -100;
        pivotMotor.SendToNXT();
        pivotMotor.WaitFor();
        pivotMotor.TachoLimit = 0;
    end
    

    %{
    while (1)
        if ~checkFront()
            forward();
            pause(2.0);
            stop();
            continue;
        end
        
        
        if ~checkLeft()
            pivot('right');

            continue;
        end
        if ~checkRight()
            pivot('left');
            
            continue;
        end
        if ~checkBehind()
            pivot('left');
            pivot('left');
            continue;
        end
            
    end
    %}
    
    pivot('right');
    
end
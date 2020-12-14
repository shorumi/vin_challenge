# VIN Validation Code Challenge

### The primary purpose of this script is to verify if a VIN is valid or not and when it is possible to suggest a correct VIN

### **What is a VIN?** 
>A vehicle identification number (VIN) (also called a chassis number or frame number) is a unique code, including a serial number, used by the automotive industry to identify individual motor vehicles, towed vehicles, motorcycles, scooters and mopeds, as defined in ISO 3779 (content and structure) and ISO 4030 (location and attachment).

Please take a look at this resource for more about it |> https://en.wikipedia.org/wiki/Vehicle_identification_number

# Tech Stack

- Ruby 2.7.2

# Running the script
In a terminal run:
```shell
ruby vin_checker.rb <VIN>
```

# Use case scenarios

## Valid VIN and expected Message output
```shell
ruby vin_checker.rb 1M8GDM9AXKP042788
```

**Provided VIN: 1M8GDM9AXKP042788  
Check Digit: VALID  
This looks like a VALID VIN!**

## Invalid VIN characters and expected Message output
```shell
 ruby vin_checker.rb INKDLUOX33R385016 
```

**Provided VIN: INKDLUOX33R385016  
Check Digit: INVALID  
Suggested VIN(s):  
  1NKDLU0X33R385016   
Invalid character(s):  
  Position: 1 value is I  
  Position: 7 value is O**

## Invalid VIN size and expected Message output
```shell
ruby vin_checker.rb 1M8GDM9AXKP04278
```

**Provided VIN: 1M8GDM9AXKP04278  
Invalid VIN size, current size: 16, it should has 17 digits**

## Invalid VIN check digit and expected Message output
```shell
ruby vin_checker.rb 1M8GDM9A0KP042788 
```

**Provided VIN: 1M8GDM9A0KP042788  
Invalid VIN check digit, current check digit: 0, expected check digit X**


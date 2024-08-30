# 🌟 SpecterScan  🕵️‍♂️🔍

![Perl Icon](https://img.shields.io/badge/Perl-%23F5DEB3?style=for-the-badge&logo=perl&logoColor=000000)![Security Icon](https://img.shields.io/badge/Security-%23FF4F4F?style=for-the-badge&logo=security&logoColor=ffffff) ![Terminal Icon](https://img.shields.io/badge/Terminal-%231d1f21?style=for-the-badge&logo=gnome-terminal&logoColor=00bfae) )

## 🎯 **Overview**

```
SpecterScan is a powerful Perl-based SQL Injection vulnerability scanner.
It helps ensure the security of your web applications by testing URLs with various payloads.
This tool identifies potential SQL injection vulnerabilities using time-based techniques to reveal delays in response times.
```

## 🚀 **Features**

```
- 🔍 Single URL Scanning: Analyze individual URLs for SQL injection vulnerabilities.
- 📋 Multiple URLs Scanning: Efficiently scan a batch of URLs from a file.
- 📜 Parameter-based Testing: Detect SQL injection vulnerabilities through URL parameters.
- 🏷️ Header-based Testing: Assess vulnerabilities in HTTP headers.
- ⏳ Time-based Scanning: Utilize time-based payloads to identify vulnerabilities by measuring delays in response times.
- 📈 Comprehensive Output: Detailed results with response times and vulnerability statuses, including specific payloads that triggered issues.
```

## 🛠️ **Installation**

```
1. Ensure Perl is Installed: Download Perl from https://www.perl.org/get.html if not already installed. 🐍

2. Install Dependencies: Use CPAN to install the necessary Perl modules:
   $ cpan install LWP::UserAgent
   $ cpan install HTTP::Request
   $ cpan install Getopt::Long
   $ cpan install Time::HiRes

3. Clone the Repository:
   $ git clone https://github.com/LunarLumos/SpecterScan.git
   $ cd SpecterScan

4. Execute the Script:
   $ perl specterscan.pl
```

## 🎨 **Usage**

```
SpecterScan provides several command-line options:

- -u <url>: Test a single URL. 🌐
- -l <list_file>: Test a list of URLs from a file. 📄
- -h: Test HTTP headers. 🏷️
- -p: Test URL parameters. 📜
```

### **Examples** 💡

#### **1. Single URL Test**

```
Test a URL for both parameter and header-based SQL injection vulnerabilities:
$ perl specterscan.pl -u "http://example.com/vulnerable_page.php?id=1" -p -h
```

#### **2. Multiple URLs Test**

```
Scan a list of URLs from a file:
$ perl specterscan.pl -l "urls.txt" -p
```

#### **3. Parameter-based Testing Only**

```
Test a URL focusing solely on parameters:
$ perl specterscan.pl -u "http://example.com/vulnerable_page.php?id=1" -p
```

#### **4. Header-based Testing Only**

```
Test a URL focusing solely on headers:
$ perl specterscan.pl -u "http://example.com/vulnerable_page.php" -h
```

## 🔍 **Methodology**

```
1. Initialization:
   - Load required modules and define ANSI color codes for enhanced output formatting. 🌈
   - Initialize the user-agent for sending HTTP requests. 🕵️‍♂️

2. Payloads:
   - Use a collection of SQL injection payloads designed to induce delays if vulnerabilities exist. 💥

3. Processing URLs:
   - Single URL: Evaluate the URL against each payload and output results. 🧪
   - List of URLs: Read and test each URL from a file, then display results. 📂

4. Testing:
   - Parameter-based Testing: Append payloads to URL parameters and measure response time. ⏱️
   - Header-based Testing: Add payloads to HTTP headers and check response time. 🏷️
   - Time-based Scanning: Measure delays in response times to detect SQL injection vulnerabilities, particularly those exploiting time-based techniques. ⏳

5. Results:
   - Compare response times with and without payloads. A significant increase may indicate a vulnerability. ⚠️
   - Print results with color-coded outputs for clarity. 🌟
```

## 📝 **Example Results**

### **1. Single URL Test - Parameter-based**

```
[ URL 1 ]: http://example.com/vulnerable_page.php?id=1
[ Mood ]: Parameter
[ Normal Response Time]: 0.12 sec
[ Payload Response Time]: 30.15 sec
[ Comment ]: Vulnerable in Parameter-based SQL
[ Payload ]: (CASE WHEN (2375=2375) THEN SLEEP(30) ELSE 2375 END)
```

### **2. Single URL Test - Header-based**

```
[ URL 1 ]: http://example.com/vulnerable_page.php
[ Mood ]: Header
[ Normal Response Time]: 0.10 sec
[ Payload Response Time]: 30.20 sec
[ Comment ]: Vulnerable in Header-based SQL
[ Header ]: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/37.0.2062.94 Chrome/37.0.2062.94 Safari/537.36 ORDER BY SLEEP(30)
```

### **3. Multiple URLs Test**

```
[ URL 1 ]: http://example.com/vulnerable_page1.php?id=1
[ Mood ]: Parameter
[ Normal Response Time]: 0.14 sec
[ Payload Response Time]: 30.25 sec
[ Comment ]: Vulnerable in Parameter-based SQL
[ Payload ]: + SLEEP(30) + '

[ URL 2 ]: http://example.com/vulnerable_page2.php
[ Mood ]: Header
[ Normal Response Time]: 0.09 sec
[ Payload Response Time]: 30.18 sec
[ Comment ]: Vulnerable in Header-based SQL
[ Header ]: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3 ORDER BY SLEEP(30)
```

## 🤝 **Contributing**

```
We welcome contributions! Please fork the repository, create a new branch, and submit a pull request with your enhancements. 🚀
```

## 📜 **License**

```
This project is licensed under the MIT License - see the LICENSE file for details. 📄
```

# Commercial Distribution Guide

This guide walks you through creating a professional, sellable installer for YouTube Downloader Pro.

## Prerequisites

Before creating your commercial installer, ensure you have:

### Required Software
- **Windows 10/11** with Administrator privileges
- **NSIS (Nullsoft Scriptable Install System)**:
  ```powershell
  winget install NSIS.NSIS
  ```
- **Java 21 SDK** and **Maven** (for building)
- **Windows SDK** (for code signing - optional but recommended)

### Required Files
- Your built application (`mvn package javafx:jlink`)
- Commercial license agreement (`LICENSE.txt`)
- Product documentation
- Company branding assets (icons, images)

## Step 1: Build the Application

```powershell
# Build the core application
mvn clean package javafx:jlink
```

This creates the self-contained Java application in `target/image/`.

## Step 2: Customize for Your Business

### Update Company Information

Edit `YouTubeDownloader-Commercial.nsi` and replace:
- `[Your Company Name]` → Your actual company name
- `https://your-website.com` → Your website URL
- Update version numbers and product descriptions

### Update License Agreement

Edit `LICENSE.txt` with your commercial license terms:
- Company name and contact information
- Pricing and licensing terms
- Usage restrictions and warranties
- Support terms and conditions

### Add Branding (Optional)

Create these image files for professional appearance:
- `icon.ico` - Application icon (32x32, 48x48, 256x256 pixels)
- `header.bmp` - Installer header image (150x57 pixels)
- `welcome.bmp` - Welcome page image (164x314 pixels)

## Step 3: Build the Commercial Installer

### Option A: Using PowerShell (Recommended)
```powershell
# Basic build
.\build-commercial.ps1

# With custom company info
.\build-commercial.ps1 -CompanyName "YourCompany" -Website "https://yoursite.com"

# Skip rebuild if already built
.\build-commercial.ps1 -SkipBuild

# Build and test immediately
.\build-commercial.ps1 -TestInstaller
```

### Option B: Using Batch File
```cmd
build-commercial.bat
```

## Step 4: Code Signing (Recommended for Commercial Software)

Code signing builds trust with customers and prevents Windows security warnings.

### Get a Code Signing Certificate

Purchase from trusted Certificate Authorities:
- **DigiCert** - Industry standard, most trusted
- **Sectigo** - Good balance of price and trust
- **GlobalSign** - Reliable alternative

### Sign Your Installer

```powershell
.\sign-installer.ps1 -CertificatePath "path\to\your\certificate.p12" -CertificatePassword "your-password"
```

## Step 5: Test the Installer

### Testing Checklist

1. **Clean Environment Testing**:
   - Test on fresh Windows installation
   - Test without dependencies (Python, FFmpeg) installed
   - Test with limited user privileges

2. **Installation Testing**:
   - Verify all components install correctly
   - Check Start Menu and Desktop shortcuts
   - Confirm file associations work
   - Test uninstaller functionality

3. **Application Testing**:
   - Launch application from shortcuts
   - Test video download functionality
   - Test audio download with and without FFmpeg
   - Verify error handling for missing dependencies

4. **Security Testing**:
   - Run on systems with antivirus software
   - Test Windows SmartScreen behavior
   - Verify signed installer shows proper publisher

## Step 6: Distribution Preparation

### File Preparation

Your final distribution package should include:
- `YouTubeDownloader-Pro-Setup.exe` (signed installer)
- Product documentation (README, user manual)
- Quick start guide
- Technical requirements document

### Documentation for Customers

Create user-friendly documentation covering:
- **System Requirements**: Windows version, disk space, dependencies
- **Installation Guide**: Step-by-step installation process
- **Quick Start**: Basic usage instructions
- **Troubleshooting**: Common issues and solutions
- **Support Contact**: How to get help

### Pricing and Licensing Strategy

Consider these licensing models:
- **One-time Purchase**: Single payment for lifetime license
- **Subscription**: Monthly/yearly recurring payments
- **Freemium**: Free version with paid premium features
- **Volume Licensing**: Discounts for multiple licenses

## Step 7: Distribution Platforms

### Direct Sales
- Your own website with payment processing
- PayPal, Stripe, or similar payment processors
- Digital delivery via download links

### Software Marketplaces
- **Microsoft Store**: Official Windows app store
- **Software distribution sites**: DownloadCrew, Softpedia, FileHippo
- **Shareware sites**: Traditional software distribution

### Marketing Considerations
- SEO-optimized product pages
- Customer testimonials and reviews
- Free trial or demo versions
- Social media presence
- Content marketing (blogs, tutorials)

## Technical Specifications

### Installer Features
- **Size**: ~80-100 MB (includes Java runtime)
- **Target**: Windows 10/11 (64-bit recommended)
- **Dependencies**: Automatically checks for Python, yt-dlp, FFmpeg
- **Installation**: ~200 MB disk space required
- **Uninstall**: Complete removal including registry entries

### Security Features
- Code signing support for trusted installation
- Registry integration for proper Windows integration
- Secure uninstallation process
- No admin rights required for application use (only installation)

## Support and Maintenance

### Customer Support Strategy
- Knowledge base with common issues
- Email support system
- Version update notifications
- Bug tracking and feature requests

### Update Distribution
- Automatic update checking (can be added to application)
- New version notifications
- Patch distribution system
- Version rollback capabilities

## Legal Considerations

### Intellectual Property
- Ensure all code is original or properly licensed
- Respect YouTube's Terms of Service
- Include proper attribution for open-source components
- Consider patent implications

### Commercial Compliance
- Business license requirements
- Tax obligations for software sales
- Consumer protection laws
- International distribution regulations

## Revenue Optimization

### Pricing Strategies
- Market research on competitor pricing
- Value-based pricing for features offered
- Regional pricing considerations
- Discount strategies for volume sales

### Feature Monetization
- Basic vs. Pro feature tiers
- Premium format support
- Batch download capabilities
- Priority customer support

---

## Quick Start Commands

```powershell
# Complete commercial build process
mvn clean package javafx:jlink
.\build-commercial.ps1 -CompanyName "Your Company" -Website "https://yoursite.com"
.\sign-installer.ps1 -CertificatePath "cert.p12" -CertificatePassword "password"
```

Your commercial installer is now ready for distribution and sales!

# How to Fix iOS CodeSign Error in Xcode

If you encounter `Command CodeSign failed with a nonzero exit code` or signing errors typically, follow these steps to configure Xcode manually:

1.  **Open the Project in Xcode**:
    *   Navigate to your project folder in Finder.
    *   Go to the `ios` folder.
    *   Double-click on `Runner.xcworkspace` (white icon). Do NOT use `Runner.xcodeproj`.

2.  **Select the Project**:
    *   In the left-hand Project Navigator (folder icon), click on the top-level **Runner** (blue icon).

3.  **Configure Signing**:
    *   In the main editor area, select the **Runner** TARGET (under the "Targets" section on the left side of the editor).
    *   Click on the **Signing & Capabilities** tab at the top.

4.  **Set Up Team**:
    *   Ensure **Automatically manage signing** is CHECKED.
    *   Locate the **Team** dropdown.
    *   Select your **Personal Team** (it usually says "Your Name (Personal Team)").
        *   *If no team is listed*: Click **Add an Account...**, sign in with your Apple ID, and then select your team.

5.  **Verify Bundle Identifier**:
    *   Ensure the **Bundle Identifier** is unique.
    *   Recommended: `com.octavertexmedia.healthyome` (or similar).

6.  **Trust the Certificate** (If deploying to physical device):
    *   If you run on a physical iPhone, go to **Settings > General > VPN & Device Management** on your phone and trust your developer certificate.

7.  **Run the App**:
    *   You can now try running `flutter run` again from your terminal, or click the **Play** button in Xcode.

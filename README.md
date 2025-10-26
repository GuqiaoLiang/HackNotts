# 👻 Triquetra: The Halloween Mystery

A mysterious Halloween night…  
An ancient **Triquetra** symbol glowing faintly…  
And a traveler lost between **time and reality**.

This Godot 4.x project brings you on a story-driven journey across timelines —  
where puzzles, ghosts, and fate intertwine.

---

## 🧩 1. Install Godot

1. Go to the official website:  
   👉 [https://godotengine.org/download](https://godotengine.org/download)
2. Download the latest **Godot 4.x (Stable)** version  
   > Recommended: **Godot 4.3** or newer
3. Extract and open the executable directly — no installation required:
   - **Windows:** `Godot_v4.x-stable_win64.exe`
   - **macOS:** drag to Applications
   - **Linux:** run the `.x86_64` binary

---

## ⚙️ 2. Open the Project

1. Launch Godot and click **"Import Project"**
2. Select the folder containing this file and `project.godot`
   ```
   your_folder/
   ├── project.godot
   ├── StartingScreen/
   │   └── StartingScreen.tscn
   ├── Player/
   ├── Scenes/
   ├── Audio/
   └── README.md
   ```
3. Click **"Import & Edit"**

---

## 🛠️ 3. Set the Main Scene

1. In the Godot editor, open:  
   **Project → Project Settings**
2. Search for: `main scene`
3. Set it to:
   ```
   res://StartingScreen/StartingScreen.tscn
   ```
4. Click **Close** to save changes.

---

## 🚀 4. Run the Game

- Press **F5** or click ▶️ **Play the Project**
- You should see the **Starting Screen**
- Use **arrow keys** or **WASD** to move the player
- Follow the story clues to explore — and beware the **ghosts** 👻

---

## 🔊 5. Optional Tweaks

### 🎧 Adjust BGM Volume
1. Open the scene with your background music node (usually `AudioStreamPlayer`)
2. In the **Inspector**, change:
   ```
   volume_db = -10
   ```

### 🖥️ Adjust Resolution
1. Go to **Project → Project Settings → Display → Window**
2. Change:
   ```
   Size → Width: 1280
   Size → Height: 720
   ```

---

## 📦 6. Export the Game (Optional)

If you want to build a standalone executable:

1. Go to **Project → Export...**
2. Click **Add Preset** → choose your platform
3. Select an output path, for example:
   ```
   build/Timebound.exe
   ```
4. Click **Export Project**

---

## ⚠️ 7. Troubleshooting

| Issue | Possible Cause | Fix |
|-------|----------------|------|
| 🕳️ Black Screen | Main scene not set | Check Project Settings → main scene |
| 🧩 Scene Missing | Wrong scene path | Confirm `res://StartingScreen/StartingScreen.tscn` exists |
| 🔇 No Music | Missing BGM file | Check `/Audio/` folder |
| ⛔ Player Not Moving | Input not mapped | Project Settings → Input Map (add ui_left/right/up/down) |

---

## ✨ Credits

- **Engine:** Godot 4.x  
- **Design & Story:** Guqiao Liang, Jessicat, Abdullah Alshamam
- **Art & Assets:** Custom / Open License  
- **Font:** Caveat.ttf (Google Fonts)  

---

> 💡 *“Time bends, memories fade — but some doors never close.”*


import java.util.ArrayList;
import processing.sound.*;

ArrayList<Cokroach> coks;
PImage img;
PImage animeCursor;
GunSound gunSound;
HitSound hitSound;
SoundFile backgroundMusic;
int lastSpawnTime = 0;
int score = 0;
int cursorWidth = 300;  
int cursorHeight = 300; 
int lastHitSoundTime = 0;

void setup() {
  size(800, 800);
  coks = new ArrayList<Cokroach>();
  img = loadImage("kecoa.png");
  animeCursor = loadImage("anime2.png");

  cursor(animeCursor, 25, 25);
  noCursor();
  
  gunSound = new GunSound(this, "gun.wav", 1);
  hitSound = new HitSound(this, "Chain.wav", 10); 
  backgroundMusic = new SoundFile(this, "PB.wav");
  backgroundMusic.loop();
}


void draw() {
  background(255);
  
  fill(0);
  textSize(24);
  
  textAlign(CENTER, CENTER);
  text("Alvin Haris Suherdi", 400, 50);  
  text("22.11.4711", 400, 70);
  
  
  // Add a Cokroach every 5 seconds at a random location
  if (millis() - lastSpawnTime > 5000) {
    float x = random(width);
    float y = random(height);
    coks.add(new Cokroach(img, x, y));
    lastSpawnTime = millis();
  }

  for (int i = coks.size() - 1; i >= 0; i--) {
    Cokroach c = coks.get(i);
    c.live();
  }
  
  fill(51);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Kecoa: " + coks.size(), 50, 750);
  text("Kill: " + score, 50, 770);
  
  imageMode(CENTER);
  image(animeCursor, mouseX, mouseY, cursorWidth, cursorHeight);
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    gunSound.play();
    for (int i = coks.size() - 1; i >= 0; i--) {
      Cokroach c = coks.get(i);
      if (dist(mouseX, mouseY, c.pos.x, c.pos.y) < img.width / 2) {
        coks.remove(i);  // Remove the clicked cockroach
        hitSound.play();
        score++;
        break;
      }
    }
  }
}

class Cokroach {
  PVector pos;
  PVector vel;
  PImage img;
  float heading;

  Cokroach(PImage _img, float _x, float _y) {
    pos = new PVector(_x, _y);
    vel = PVector.random2D();
    heading = 0;
    img = _img;
  }
  
  void live() {
    pos.add(vel);
    
    if (pos.x <= 0 || pos.x >= width) vel.x *= -1;
    if (pos.y <= 0 || pos.y >= height) vel.y *= -1;
    
    heading = atan2(vel.y, vel.x);
    pushMatrix();
      imageMode(CENTER);
      translate(pos.x, pos.y);
      rotate(heading + 0.5 * PI);
      image(img, 0, 0);
    popMatrix();
  }
}

class SoundEffect {
  SoundFile[] sounds;
  int soundIndex = 0;

  SoundEffect(PApplet app, String fileName, int poolSize) {
    sounds = new SoundFile[poolSize];
    for (int i = 0; i < poolSize; i++) {
      sounds[i] = new SoundFile(app, fileName);
    }
  }

  void play() {
    sounds[soundIndex].play();
    soundIndex = (soundIndex + 1) % sounds.length;
  }
}

class GunSound extends SoundEffect {
  GunSound(PApplet app, String fileName, int poolSize) {
    super(app, fileName, poolSize);
  }
}

class HitSound extends SoundEffect {
  HitSound(PApplet app, String fileName, int poolSize) {
    super(app, fileName, poolSize);
  }
}

ArrayList<PVector> particles;
float noiseScale = 0.01;
int particleCount = 10000;

void setup() {
  size(600, 600);
  particles = new ArrayList<PVector>();
  for (int i = 0; i < particleCount; i++) {
    particles.add(new PVector(random(width), random(height)));
  }
}

void draw() {
  background(0);
  stroke(255);
  for (PVector pv: particles) {
    point(pv.x, pv.y);
    float noiseValue = noise(pv.x * noiseScale, pv.y * noiseScale);
    float angle = TAU * noiseValue;
    pv.x += cos(angle);
    pv.y += sin(angle);
    
    if (!isOnScreen(pv)) {
      pv.x = random(width);
      pv.y = random(height);
    }
  }
}

boolean isOnScreen(PVector pv) {
  return pv.x >= 0 && pv.x <= width && pv.y >= 0 && pv.y <= height;
}

void mouseReleased() {
  noiseSeed(millis()); // Zufallsseed abhängig von der vergangenen Zeit
}

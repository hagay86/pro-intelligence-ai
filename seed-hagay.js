// Seeds a professional account for Hagay so he can log in straight away.
// Run with: node --experimental-sqlite seed-hagay.js
//
// Safe to re-run: skips if user/room already exists.

import { DatabaseSync } from "node:sqlite";
import bcrypt from "bcryptjs";
import crypto from "node:crypto";
import path from "node:path";
import fs from "node:fs";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DATA_DIR = path.join(__dirname, "data");
fs.mkdirSync(DATA_DIR, { recursive: true });

const EMAIL = "hagaydardik@gmail.com";
// Use SEED_PASSWORD=... to choose one; otherwise a strong random password is generated.
const PASSWORD = process.env.SEED_PASSWORD || crypto.randomBytes(9).toString("base64url");
const NAME = "Hagay Dardik";
const ROOM_NAME = "Digital Advertising Mastery";
const ROOM_TOPIC = "Meta ads, Google ads, creative testing, the playbook I run for clients";

const db = new DatabaseSync(path.join(DATA_DIR, "synapse.sqlite"));

db.exec(`
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL COLLATE NOCASE,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('professional','student')),
    color TEXT NOT NULL DEFAULT 'cyan',
    created_at INTEGER NOT NULL
  );
  CREATE TABLE IF NOT EXISTS rooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    topic TEXT,
    professional_id INTEGER NOT NULL,
    invite_code TEXT UNIQUE NOT NULL,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (professional_id) REFERENCES users(id)
  );
  CREATE TABLE IF NOT EXISTS room_members (
    room_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    joined_at INTEGER NOT NULL,
    PRIMARY KEY (room_id, user_id)
  );
  CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id INTEGER NOT NULL,
    author_id INTEGER,
    type TEXT NOT NULL CHECK(type IN ('human','ai')),
    content TEXT NOT NULL,
    asked_ai INTEGER DEFAULT 0,
    asked_by INTEGER,
    grounded_in INTEGER,
    ts INTEGER NOT NULL
  );
  CREATE TABLE IF NOT EXISTS notes (
    room_id INTEGER PRIMARY KEY,
    content TEXT NOT NULL DEFAULT '',
    updated_at INTEGER NOT NULL DEFAULT 0,
    message_count INTEGER NOT NULL DEFAULT 0
  );
  CREATE TABLE IF NOT EXISTS sessions (
    token TEXT PRIMARY KEY,
    user_id INTEGER NOT NULL,
    created_at INTEGER NOT NULL,
    expires_at INTEGER NOT NULL
  );
  CREATE INDEX IF NOT EXISTS idx_messages_room ON messages(room_id, ts);
  CREATE INDEX IF NOT EXISTS idx_room_members_user ON room_members(user_id);
`);

const existing = db.prepare("SELECT * FROM users WHERE email = ?").get(EMAIL);
let userId;
let passwordSet = false;
if (existing) {
  userId = existing.id;
  if (process.env.SEED_PASSWORD || process.argv.includes("--reset-password")) {
    const hash = bcrypt.hashSync(PASSWORD, 10);
    db.prepare("UPDATE users SET password_hash = ? WHERE id = ?").run(hash, existing.id);
    passwordSet = true;
    console.log(`✓  Found existing account for ${EMAIL} — password reset.`);
  } else {
    console.log(`✓  Found existing account for ${EMAIL} — password unchanged.`);
  }
} else {
  const hash = bcrypt.hashSync(PASSWORD, 10);
  const result = db.prepare(
    "INSERT INTO users (email, password_hash, name, role, color, created_at) VALUES (?, ?, ?, 'professional', 'violet', ?)"
  ).run(EMAIL, hash, NAME, Date.now());
  userId = result.lastInsertRowid;
  passwordSet = true;
  console.log(`✓  Created professional account: ${EMAIL}`);
}

const existingRoom = db.prepare("SELECT * FROM rooms WHERE professional_id = ? AND name = ?").get(userId, ROOM_NAME);
let roomId, inviteCode;
if (existingRoom) {
  roomId = existingRoom.id;
  inviteCode = existingRoom.invite_code;
  console.log(`✓  Room "${ROOM_NAME}" already exists (code: ${inviteCode})`);
} else {
  inviteCode = crypto.randomBytes(4).toString("hex").toUpperCase().slice(0, 6);
  const result = db.prepare(
    "INSERT INTO rooms (name, topic, professional_id, invite_code, created_at) VALUES (?, ?, ?, ?, ?)"
  ).run(ROOM_NAME, ROOM_TOPIC, userId, inviteCode, Date.now());
  roomId = result.lastInsertRowid;
  console.log(`✓  Created room "${ROOM_NAME}" — invite code: ${inviteCode}`);
}

db.prepare("INSERT OR IGNORE INTO room_members (room_id, user_id, joined_at) VALUES (?, ?, ?)")
  .run(roomId, userId, Date.now());

console.log("");
console.log("  ╭─────────────────────────────────────────────╮");
console.log("  │  Ready to log in                            │");
console.log(`  │  email:    ${EMAIL.padEnd(33)}│`);
console.log(`  │  password: ${(passwordSet ? PASSWORD : "(unchanged)").padEnd(33)}│`);
console.log(`  │  room:     ${ROOM_NAME.padEnd(33)}│`);
console.log(`  │  invite:   ${inviteCode.padEnd(33)}│`);
console.log("  ╰─────────────────────────────────────────────╯");
console.log("");
console.log("Now run:  npm start  →  http://localhost:3000");

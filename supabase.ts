import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://arcfosanziyzeypdtzoi.supabase.co'
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFyY2Zvc2Fueml5ZXlwZHR6b2kiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTc3MTM5MTU4MywiZXhwIjoyMDg2OTY3NTgzfQ8ktP2RZGIx08IKgFKsRFtWncRY-nvPhiB6VdYrt0HS8'

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Types
export interface Profile {
  id: string
  user_id: string
  age: number
  weight: number
  height: number
  gender: 'male' | 'female' | 'other'
  level: 'beginner' | 'intermediate' | 'advanced'
  goal: 'muscle' | 'fat_loss' | 'strength' | 'endurance'
  location_pref: 'home' | 'gym' | 'mixed'
  diet_restrictions: string[]
  created_at: string
  updated_at: string
}

export interface Exercise {
  id: string
  name: string
  description: string
  muscle_group: string
  equipment_needed: 'none' | 'dumbbell' | 'barbell' | 'machine' | 'bands'
  image_url: string
  is_bodyweight: boolean
}

export interface WorkoutPlan {
  id: string
  user_id: string
  created_at: string
  status: 'active' | 'archived'
}

export interface PlanDay {
  id: string
  plan_id: string
  day_number: number
  day_name: string
}

export interface WorkoutItem {
  id: string
  plan_day_id: string
  exercise_id: string
  exercise?: Exercise
  sets: number
  reps: string
  rest_time: number
  notes?: string
}

export interface DietPlan {
  id: string
  user_id: string
  day_number: number
  calories: number
  protein: number
  carbs: number
  fats: number
  meals: Meal[]
}

export interface Meal {
  name: string
  description: string
  calories: number
  protein: number
  carbs: number
  fats: number
}

export interface ProgressLog {
  id: string
  user_id: string
  date: string
  weight?: number
  completed_exercises: string[]
  meals_logged: number
}

export interface Badge {
  id: string
  name: string
  description: string
  icon: string
  earned_at?: string
}

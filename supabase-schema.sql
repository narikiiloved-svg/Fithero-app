-- FitHero Database Schema for Supabase

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  user_id UUID UNIQUE NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  age INTEGER,
  weight DECIMAL(5,2),
  height DECIMAL(5,2),
  gender VARCHAR(20),
  level VARCHAR(20) DEFAULT 'beginner',
  goal VARCHAR(20) DEFAULT 'muscle',
  location_pref VARCHAR(20) DEFAULT 'home',
  diet_restrictions TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Exercises library
CREATE TABLE IF NOT EXISTS exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  muscle_group VARCHAR(50),
  equipment_needed VARCHAR(20) DEFAULT 'none',
  image_url TEXT,
  is_bodyweight BOOLEAN DEFAULT true
);

-- Workout Plans
CREATE TABLE IF NOT EXISTS workout_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  status VARCHAR(20) DEFAULT 'active'
);

-- Plan Days
CREATE TABLE IF NOT EXISTS plan_days (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plan_id UUID NOT NULL REFERENCES workout_plans(id) ON DELETE CASCADE,
  day_number INTEGER NOT NULL,
  day_name VARCHAR(50) NOT NULL
);

-- Workout Items (exercises in a plan day)
CREATE TABLE IF NOT EXISTS workout_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  plan_day_id UUID NOT NULL REFERENCES plan_days(id) ON DELETE CASCADE,
  exercise_id UUID REFERENCES exercises(id) ON DELETE SET NULL,
  exercise_name VARCHAR(100),
  description TEXT,
  sets INTEGER DEFAULT 3,
  reps VARCHAR(20) DEFAULT '10',
  rest_time INTEGER DEFAULT 60,
  notes TEXT,
  is_bodyweight BOOLEAN DEFAULT true
);

-- Diet Plans
CREATE TABLE IF NOT EXISTS diet_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  day_number INTEGER NOT NULL,
  calories INTEGER DEFAULT 2000,
  protein INTEGER DEFAULT 150,
  carbs INTEGER DEFAULT 200,
  fats INTEGER DEFAULT 65,
  meals JSONB
);

-- Progress Logs
CREATE TABLE IF NOT EXISTS progress_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  weight DECIMAL(5,2),
  completed_exercises TEXT[] DEFAULT '{}',
  meals_logged INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Badges
CREATE TABLE IF NOT EXISTS user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_name VARCHAR(50) NOT NULL,
  badge_description TEXT,
  earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE plan_days ENABLE ROW LEVEL SECURITY;
ALTER TABLE workout_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE diet_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own workout plans" ON workout_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create workout plans" ON workout_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own workout plans" ON workout_plans FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own plan days" ON plan_days FOR SELECT USING (
  EXISTS (SELECT 1 FROM workout_plans WHERE workout_plans.id = plan_days.plan_id AND workout_plans.user_id = auth.uid())
);
CREATE POLICY "Users can create plan days" ON plan_days FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM workout_plans WHERE workout_plans.id = plan_days.plan_id AND workout_plans.user_id = auth.uid())
);

CREATE POLICY "Users can view own workout items" ON workout_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM plan_days pd JOIN workout_plans wp ON pd.plan_id = wp.id WHERE workout_items.plan_day_id = pd.id AND wp.user_id = auth.uid())
);
CREATE POLICY "Users can create workout items" ON workout_items FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM plan_days pd JOIN workout_plans wp ON pd.plan_id = wp.id WHERE workout_items.plan_day_id = pd.id AND wp.user_id = auth.uid())
);

CREATE POLICY "Users can view own diet plans" ON diet_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create diet plans" ON diet_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own diet plans" ON diet_plans FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own progress logs" ON progress_logs FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create progress logs" ON progress_logs FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own progress logs" ON progress_logs FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own badges" ON user_badges FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create badges" ON user_badges FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Insert default exercises
INSERT INTO exercises (name, description, muscle_group, equipment_needed, image_url, is_bodyweight) VALUES
('Push-ups', 'Colócate en posición de plancha con las manos separadas al ancho de los hombros. Baja el cuerpo hasta que el pecho casi toque el suelo, manteniendo el cuerpo recto. Empuja hacia arriba para volver a la posición inicial. Mantén los codos pegados al cuerpo durante el movimiento.', 'Pecho, Tríceps, Hombros', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Push_Up_Exercise.PNG/640px-Push_Up_Exercise.PNG', true),
('Squats', 'Párate con los pies separados al ancho de los hombros. Baja el cuerpo como si fueras a sentarte, manteniendo el pecho erguido y las rodillas detrás de los dedos de los pies. Baja hasta que los muslos estén平行 al suelo y luego vuelve a subir.', 'Cuádriceps, Glúteos, Isquiotibiales', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Squats.PNG/640px-Squats.PNG', true),
('Plank', 'Colócate boca abajo sobre los antebrazos y las puntas de los pies. Mantén el cuerpo en línea recta desde la cabeza hasta los talones. Aprieta el core y mantén la posición sin dejar que la cadera suba o baje.', 'Core, Hombros, Espalda', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Plank_pose.svg/640px-Plank_pose.svg.png', true),
('Lunges', 'Párate derecho y da un paso adelante con una pierna, bajando el cuerpo hasta que ambas rodillas estén a 90 grados. La rodilla trasera debe casi tocar el suelo. Vuelve a la posición inicial y repite con la otra pierna.', 'Cuádriceps, Glúteos, Isquiotibiales', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Lunge.PNG/640px-Lunge.PNG', true),
('Burpees', 'Desde posición de pie, baja a una posición de sentadilla con las manos en el suelo. Salta los pies hacia atrás para entrar en posición de plancha. Haz una flexión. Salta los pies hacia adelante y luego salta hacia arriba con los brazos arriba.', 'Cuerpo completo', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Burpee_Muscle_Groups.svg/640px-Burpee_Muscle_Groups.svg.png', true),
('Mountain Climbers', 'Comienza en posición de plancha. Alterna llevando las rodillas hacia el pecho lo más rápido posible, como si estuvieras corriendo en el suelo. Mantén las caderas niveladas y el core apretado.', 'Core, Cuádriceps, Hombros', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Mountain_Climber_Exercise.PNG/640px-Mountain_Climber_Exercise.PNG', true),
('Pull-ups', 'Cuelgate de una barra con las manos separadas al ancho de los hombros, palmas hacia afuera. Tira del cuerpo hacia arriba hasta que el mentón pase la barra. Baja controladamente y repite.', 'Espalda, Bíceps', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Pull-up_exercise.PNG/640px-Pull-up_exercise.PNG', true),
('Dips', 'Colócate entre barras paralelas o usa una silla. Baja el cuerpo flexionando los codos hasta que los brazos estén a 90 grados. Empuja hacia arriba para volver a la posición inicial.', 'Tríceps, Pecho, Hombros', 'none', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Triceps_Dips.PNG/640px-Triceps_Dips.PNG', true),
('Bench Press', 'Acuéstate en un banco con los pies en el suelo. Sostén la barra con las manos separadas al ancho de los hombros. Baja la barra hasta el pecho y luego empuja hacia arriba hasta que los brazos estén extendidos.', 'Pecho, Tríceps, Hombros', 'barbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Bench_Press.PNG/640px-Bench_Press.PNG', false),
('Deadlift', 'Párate con los pies separados al ancho de los hombros, la barra frente a ti. Mantén la espalda recta y baja la barra agarrándola con las manos separadas al ancho de los hombros. Levanta la barra manteniendo la espalda recta y las rodillas ligeramente flexionadas.', 'Espalda, Glúteos, Isquiotibiales', 'barbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Deadlift.PNG/640px-Deadlift.PNG', false),
('Barbell Squats', 'Colócate debajo de una barra sobre los trapezios. Los pies separados al ancho de los hombros. Baja el cuerpo manteniendo la espalda recta hasta que los muslos estén平行 al suelo. Vuelve a subir extendiendo las piernas.', 'Cuádriceps, Glúteos, Core', 'barbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Barbell_Squat.PNG/640px-Barbell_Squat.PNG', false),
('Bent Over Rows', 'Inclínate hacia adelante manteniendo la espalda recta. Sostén la barra con las manos separadas al ancho de los hombros. Tira de la barra hacia el abdomen, manteniendo los codos pegados al cuerpo. Baja controladamente.', 'Espalda, Bíceps', 'barbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Bent_Over_Row.PNG/640px-Bent_Over_Row.PNG', false),
('Overhead Press', 'Párate con los pies separados al ancho de los hombros. Sostén la barra a la altura de los hombros. Empuja la barra hacia arriba hasta que los brazos estén completamente extendidos. Baja controladamente.', 'Hombros, Tríceps', 'barbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Overhead_Press.PNG/640px-Overhead_Press.PNG', false),
('Dumbbell Curls', 'Párate con una mancuerna en cada mano, brazos extendidos a los lados. Flexiona los codos para levantar las mancuernas hacia los hombros. Mantén los codos quietos y baja controladamente.', 'Bíceps', 'dumbbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Dumbbell_Curl.PNG/640px-Dumbbell_Curl.PNG', false),
('Tricep Extensions', 'Sostén una mancuerna con ambas manos encima de la cabeza. Baja la mancuerna detrás de la cabeza flexionando los codos. Extiende los brazos para volver a la posición inicial.', 'Tríceps', 'dumbbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Tricep_Extension.PNG/640px-Tricep_Extension.PNG', false),
('Shoulder Fly', 'Acuéstate en un banco con una mancuerna en cada mano. Extiende los brazos hacia arriba. Abre los brazos en arco hasta que las mancuernas estén a la altura de los hombros. Baja controladamente.', 'Hombros', 'dumbbell', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Shoulder_Fly.PNG/640px-Shoulder_Fly.PNG', false),
('Leg Press', 'Siéntate en la máquina de leg press con los pies separados al ancho de los hombros en la plataforma. Baja el peso flexionando las rodillas hasta 90 grados. Empuja hacia arriba sin bloquear las rodillas.', 'Cuádriceps, Glúteos', 'machine', 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Leg_Press.PNG/640px-Leg_Press.PNG', false),
('Lat Pulldown', 'Siéntate en la máquina de polea alta y agarra la barra más ancha que los hombros. Tira de la barra hacia el pecho, llevando los codos hacia abajo. Contrae los dorsales en la parte inferior y vuelve controladamente.', 'Espalda, Bíceps', 'machine', 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Lat_Pulldown.PNG/640px-Lat_Pulldown.PNG', false),
('Cable Rows', 'Siéntate en la máquina de remo con los pies en los reposapiés. Agarra la empuñadura y tira de ella hacia el abdomen, manteniendo la espalda recta. Contrae los dorsales y vuelve controladamente.', 'Espalda, Bíceps', 'machine', 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Cable_Row.PNG/640px-Cable_Row.PNG', false),
('Leg Curls', 'Acuéstate boca abajo en la máquina de curl de piernas. Coloca los talones debajo del rodillo. Flexiona las rodillas para levantar el peso hacia los glúteos. Baja controladamente.', 'Isquiotibiales', 'machine', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Leg_Curl.PNG/640px-Leg_Curl.PNG', false);

-- Create function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, user_id, created_at, updated_at)
  VALUES (NEW.id, NEW.id, NOW(), NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

<?php

namespace App\Filament\Resources\Memorials\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class MemorialsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('full_name')
                    ->label('Name')
                    ->searchable()
                    ->sortable()
                    ->description(fn ($record): ?string => $record->profession ?: null),

                TextColumn::make('category')
                    ->badge()
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'historical' => 'Historical',
                        'animal_companion' => 'Companion',
                        default => 'Family',
                    })
                    ->color(fn (string $state): string => match ($state) {
                        'historical' => 'warning',
                        'animal_companion' => 'success',
                        default => 'gray',
                    }),

                TextColumn::make('privacy')
                    ->badge()
                    ->color(fn (string $state): string => $state === 'public' ? 'success' : 'gray'),

                IconColumn::make('is_seed')
                    ->label('Curated')
                    ->boolean(),

                TextColumn::make('candle_count')
                    ->label('Candles')
                    ->numeric()
                    ->sortable(),

                TextColumn::make('contributions_count')
                    ->label('Tributes')
                    ->counts('contributions')
                    ->badge(),

                TextColumn::make('updated_at')
                    ->label('Updated')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(),
            ])
            ->defaultSort('updated_at', 'desc')
            ->filters([
                SelectFilter::make('category')
                    ->options([
                        'civilian' => 'Family record',
                        'historical' => 'Historical figure',
                        'animal_companion' => 'Animal companion',
                    ]),

                SelectFilter::make('privacy')
                    ->options([
                        'public' => 'Public',
                        'private_link' => 'Unlisted',
                        'family_only' => 'Family only',
                    ]),

                TernaryFilter::make('is_seed')->label('Curated records'),
            ])
            ->recordActions([
                ViewAction::make(),
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    // Deleting a dossier removes the tributes left on it, so it
                    // stays behind a confirmation and out of casual reach.
                    DeleteBulkAction::make()->requiresConfirmation(),
                ]),
            ]);
    }
}
